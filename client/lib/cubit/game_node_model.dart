import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'game_node_model.g.dart';

abstract class GameNode implements Built<GameNode, GameNodeBuilder> {
  bool get isActive;
  String? get userId;

  GameNode._();

  factory GameNode.init() {
    return GameNode((b) => b
      ..isActive = false
      ..userId = null);
  }

  factory GameNode([void Function(GameNodeBuilder) updates]) = _$GameNode;
}
