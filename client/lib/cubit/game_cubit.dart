import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:client/cubit/game_node_model.dart';
import 'package:client/get_it.dart';
import 'package:client/services/auth_service.dart';
import 'package:client/services/game_event_service.dart';
import 'package:client/services/room_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'game_state.dart';

final LiveQuery liveQuery = LiveQuery();

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState.empty());

  final _authService = getIt<AuthService>();
  final _roomService = getIt<RoomService>();
  final _gameEventService = getIt<GameEventService>();

  Room? room;
  late Subscription roomSubscription;
  Timer? timer;

  Future<void> init(String roomId, int height, int width) async {
    print('game cubit init');

    await _roomService.participateRoom(roomId);
    await _gameEventService.initRoomEventsSubscription(roomId);

    room = await _roomService.getRoom(roomId);

    emit(GameState.init(
        room: room!,
        nodesLengthVertical: height,
        nodesLengthHorizontal: width));

    QueryBuilder<ParseObject> roomQuery =
        QueryBuilder<ParseObject>(ParseObject('Room'))
          ..whereEqualTo('objectId', roomId);
    roomSubscription = await liveQuery.client.subscribe(roomQuery);
    roomSubscription.on(LiveQueryEvent.update, (value) {
      print('Room update');
      print(value);
      emit(state.rebuild((b) => b
        ..isStarted = value.get('isStarted')
        ..participants =
            BuiltSet<String>(value.get('participants')).toBuilder()));
    });

    _gameEventService.subscription.on(LiveQueryEvent.create, (value) {
      print('Game event update');
      updateNode(value.get('y'), value.get('x'), value.get('creatorId'));
    });
  }

  Future<void> startGame() async {
    await _roomService.startGame(room!.objectId!);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(state.rebuild((b) => b..timerValue = state.timerValue + 1));
    });
  }

  void tapNode(int y, int x) async {
    if (!state.nodes[y][x].isActive) {
      await AudioPlayer().play(AssetSource('sound.mp3'));

      updateNode(y, x, _authService.user!.objectId!);
      await _gameEventService.create(room!.objectId!, x, y);
    }
  }

  updateNode(int y, int x, String creatorId) {
    BuiltList<BuiltList<GameNode>> nodes = state.nodes;

    int count = 0;

    nodes.forEach((row) => row.forEach((node) {
          if (node.isActive) count++;
        }));

    if (count == nodes.length * nodes.length - 1) {
      timer?.cancel();
      print('game finished');
    }

    BuiltList<GameNode> updatedRow = (state.nodes[y].toList()
          ..removeAt(x)
          ..insert(
              x,
              state.nodes[y][x].rebuild((b) => b
                ..isActive = true
                ..userId = creatorId)))
        .toBuiltList();

    // print('before');
    // print(state.nodes);
    // print('after');
    // print(state.rebuild((b) => b
    //   ..nodes = (nodes.toList()
    //         ..removeAt(y)
    //         ..insert(y, updatedRow))
    //       .toBuiltList()
    //       .toBuilder()));

    emit(state.rebuild((b) => b
      ..nodes = (nodes.toList()
            ..removeAt(y)
            ..insert(y, updatedRow))
          .toBuiltList()
          .toBuilder()));
  }

  dispose() async {
    await _roomService.exitRoom(room!.objectId!);
    liveQuery.client.unSubscribe(roomSubscription);
    _gameEventService.disposeRoomEventsSubscription();
  }
}
