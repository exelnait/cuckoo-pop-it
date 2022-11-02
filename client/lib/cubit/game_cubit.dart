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

  Future<void> init(String roomId, int height, int width) async {
    room = await _roomService.getRoom(roomId);
    print(room);

    emit(GameState.init(
        nodesLengthHorizontal: width, nodesLengthVertical: height));

    QueryBuilder<ParseObject> roomQuery =
        QueryBuilder<ParseObject>(ParseObject('Room'))
          ..whereEqualTo('objectId', roomId);
    Subscription subscription = await liveQuery.client.subscribe(roomQuery);
    subscription.on(LiveQueryEvent.create, (value) {
      print('*** CREATE ***: ${DateTime.now().toString()}\n $value ');
      print((value as ParseObject).objectId);
      print((value as ParseObject).updatedAt);
      print((value as ParseObject).createdAt);
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
}
