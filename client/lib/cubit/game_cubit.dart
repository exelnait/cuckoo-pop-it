import 'package:built_collection/built_collection.dart';
import 'package:built_collection/built_collection.dart';
import 'package:client/cubit/game_node_model.dart';
import 'package:client/services/room_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'game_state.dart';

final LiveQuery liveQuery = LiveQuery();

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState.empty());

  final _roomService = RoomService();

  Room? room;
  late Subscription roomSubscription;

  Future<void> init(String roomId, int height, int width) async {
    await _roomService.participateRoom(roomId);

    room = await _roomService.getRoom(roomId);

    emit(GameState.init(room: room!, nodesLengthVertical: height, nodesLengthHorizontal: width));

    QueryBuilder<ParseObject> roomQuery =
      QueryBuilder<ParseObject>(ParseObject('Room'))..whereEqualTo('objectId', roomId);
    roomSubscription = await liveQuery.client.subscribe(roomQuery);
    roomSubscription.on(LiveQueryEvent.update, (value) {
      print('*** UPDATE ***: ${DateTime.now().toString()}\n $value ');
      print((value as ParseObject).objectId);

      emit(state.rebuild((b) => b.participants = BuiltSet<String>(value.get('participants')).toBuilder()));
    });
  }

  void tapNode(int y, int x) {
    BuiltList<BuiltList<GameNode>> nodes = state.nodes;

    BuiltList<GameNode> row = state.nodes[y];

    GameNode node = nodes[y][x];

    emit(state.rebuild((b) => b
      ..nodes = (nodes.toList()
            ..removeAt(y)
            ..insert(
                x,
                (row.toList()
                      ..removeAt(x)
                      ..insert(x, node.rebuild((b) => b..isActive = true)))
                    .toBuiltList()))
          .toBuiltList()
          .toBuilder()));
  }

  dispose() async {
    await _roomService.exitRoom(room!.objectId!);
    liveQuery.client.unSubscribe(roomSubscription);
  }
}
