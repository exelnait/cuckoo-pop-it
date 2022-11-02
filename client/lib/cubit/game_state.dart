import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:client/cubit/game_node_model.dart';
import 'package:client/services/room_service.dart';

part 'game_state.g.dart';

abstract class GameState implements Built<GameState, GameStateBuilder> {
  String get title;
  bool get isLoading;
  bool get isLoaded;
  bool get isStarted;
  bool get isFinished;
  BuiltSet<String> get participants;
  BuiltList<BuiltList<GameNode>> get nodes;
  int get timerValue;

  GameState._();

  factory GameState.empty() {
    return GameState((b) => b
      ..title = ''
      ..isLoading = true
      ..isLoaded = false
      ..isFinished = false
      ..isStarted = false
      ..timerValue = 0
      ..participants = BuiltSet<String>().toBuilder()
      ..nodes = BuiltList<BuiltList<GameNode>>().toBuilder());
  }

  factory GameState.init({
    required Room room,
    nodesLengthVertical = 10,
    nodesLengthHorizontal = 10,
  }) {
    return GameState((b) => b
      ..title = room.title
      ..isLoading = false
      ..isLoaded = true
      ..isFinished = false
      ..isStarted = false
      ..timerValue = 0
      ..participants = BuiltSet<String>(room.participants!).toBuilder()
      ..nodes = BuiltList<BuiltList<GameNode>>(List.generate(
          nodesLengthVertical,
          (_) => BuiltList<GameNode>(List.filled(nodesLengthHorizontal, 0)
              .map((e) => GameNode.init())
              .toList()))).toBuilder());
  }

  factory GameState([void Function(GameStateBuilder) updates]) = _$GameState;
}
