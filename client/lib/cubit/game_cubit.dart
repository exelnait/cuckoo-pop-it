import 'package:audioplayers/audioplayers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:client/cubit/game_node_model.dart';
import 'package:client/services/room_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'game_state.dart';

final LiveQuery liveQuery = LiveQuery();

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState.empty());

  final AudioPlayer player = AudioPlayer();

  static const String filePath = 'sound.mp3';

  final _roomService = RoomService();

  Room? room;
  late Subscription roomSubscription;

  Future<void> init(String roomId, int height, int width) async {
    await _roomService.participateRoom(roomId);

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
      print('*** UPDATE ***: ${DateTime.now().toString()}\n $value ');
      print((value as ParseObject).objectId);

      emit(state.rebuild((b) => b.participants =
          BuiltSet<String>(value.get('participants')).toBuilder()));
    });
  }

  void tapNode(int y, int x) {
    // player.play(AssetSource('assets/sound.mp3'));

    BuiltList<BuiltList<GameNode>> nodes = state.nodes;

    BuiltList<GameNode> updatedRow = (state.nodes[y].toList()
          ..removeAt(x)
          ..insert(
              x,
              state.nodes[y][x]
                  .rebuild((b) => b..isActive = !state.nodes[y][x].isActive)))
        .toBuiltList();

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
