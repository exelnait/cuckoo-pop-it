import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:client/cubit/game_node_model.dart';

part 'game_state.g.dart';

abstract class GameState implements Built<GameState, GameStateBuilder> {
  bool get isLoading;
  bool get isLoaded;
  bool get isFinished;
  BuiltSet<String> get participants;
  BuiltList<BuiltList<GameNode>> get nodes;

  GameState._();

  factory GameState.empty() {
    return GameState((b) => b
      ..isLoading = false
      ..isLoaded = false
      ..isFinished = false
      ..participants = BuiltSet<String>().toBuilder()
      ..nodes = BuiltList<BuiltList<GameNode>>().toBuilder());
  }

  factory GameState.init({
    nodesLengthVertical = 10,
    nodesLengthHorizontal = 10,
  }) {
    return GameState((b) => b
      ..isLoading = false
      ..isLoaded = false
      ..isFinished = false
      ..participants = BuiltSet<String>().toBuilder()
      ..nodes = BuiltList<BuiltList<GameNode>>(List.generate(
          nodesLengthVertical,
          (_) => BuiltList<GameNode>(List.filled(nodesLengthHorizontal, 0)
              .map((e) => GameNode.init())
              .toList()))).toBuilder());
  }

  factory GameState([void Function(GameStateBuilder) updates]) = _$GameState;
}
