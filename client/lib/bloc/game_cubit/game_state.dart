part of 'game_cubit.dart';

class GameState extends Equatable {
  const GameState({this.nodes = const []});

  final List<List<int>> nodes;

  @override
  List<Object?> get props => [nodes];

  GameState copyWith({
    List<List<int>>? nodes,
  }) {
    return GameState(
      nodes: nodes ?? this.nodes,
    );
  }
}
