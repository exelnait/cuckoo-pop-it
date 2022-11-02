import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState());

  void init(int height, int width) {
    emit(state.copyWith(
        nodes: List.generate(height, (_) => List.filled(width, 0))));
  }

  void tapNode(int y, int x) {
    List<int> row = List.of(state.nodes[y])
      ..removeAt(x)
      ..insert(x, 1);

    emit(state.copyWith(
        nodes: List.of(state.nodes)
          ..removeAt(y)
          ..insert(y, row)));
  }
}
