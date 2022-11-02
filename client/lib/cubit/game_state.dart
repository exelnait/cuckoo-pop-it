import 'dart:ui';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:client/cubit/game_node_model.dart';
import 'package:client/services/room_service.dart';
import 'package:client/utils.dart';

part 'game_state.g.dart';

abstract class GameState implements Built<GameState, GameStateBuilder> {
  String get title;

  bool get isLoading;

  bool get isLoaded;

  bool get isStarted;

  bool get isFinished;

  BuiltMap<String, Participant> get participants;

  BuiltList<BuiltList<GameNode>> get nodes;

  GameState._();

  factory GameState.empty() {
    return GameState((b) => b
      ..title = ''
      ..isLoading = true
      ..isLoaded = false
      ..isFinished = false
      ..isStarted = false
      ..participants = BuiltMap<String, Participant>().toBuilder()
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
      ..participants = BuiltMap<String, Participant>({ for (var id in room.participants!) id : Participant(
              id: id,
              name: Utils.generateUserName(),
              color: Utils.generateColor()) }).toBuilder()
      ..nodes = BuiltList<BuiltList<GameNode>>(List.generate(
          nodesLengthVertical,
          (_) => BuiltList<GameNode>(List.filled(nodesLengthHorizontal, 0)
              .map((e) => GameNode.init())
              .toList()))).toBuilder());
  }

  factory GameState([void Function(GameStateBuilder) updates]) = _$GameState;

  static BuiltMap<String, Participant> getParticipants(BuiltMap<String, Participant>  oldParticipants, List<dynamic> newParticipants) {
    return BuiltMap<String, Participant>(Map.fromIterable(newParticipants, key: (id) => id, value: (v) {
    if (oldParticipants.containsKey(v)) {
        return oldParticipants[v]!;
      } else {
        return Participant(
            id: v,
            name: Utils.generateUserName(),
            color: Utils.generateColor());
      }
    }));
  }
}

class Participant {
  final String id;
  final String name;
  final Color? color;

  Participant({required this.id, required this.name, this.color});
}
