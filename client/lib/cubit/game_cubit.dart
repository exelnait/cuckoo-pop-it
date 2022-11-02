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
      emit(state.rebuild((b) => b.participants =
          BuiltSet<String>(value.get('participants')).toBuilder()));
    });

    _gameEventService.subscription.on(LiveQueryEvent.create, (value) {
      print('Game event update');
      updateNode(value.get('y'), value.get('x'), value.get('creatorId'));
    });
  }

  void tapNode(int y, int x) async {
    await AudioPlayer().play(AssetSource('sound.mp3'));

    updateNode(y, x, _authService.user!.objectId!);
    await _gameEventService.create(room!.objectId!, y, x);
  }

  updateNode(int y, int x, String creatorId) {
    BuiltList<BuiltList<GameNode>> nodes = state.nodes;

    BuiltList<GameNode> updatedRow = (state.nodes[y].toList()
          ..removeAt(x)
          ..insert(
              x,
              state.nodes[y][x].rebuild((b) => b
                ..isActive = true
                ..userId = creatorId)))
        .toBuiltList();

    print('before');
    print(state.nodes);
    print('after');
    print(state.rebuild((b) => b
      ..nodes = (nodes.toList()
            ..removeAt(y)
            ..insert(y, updatedRow))
          .toBuiltList()
          .toBuilder()));

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
  }
}
