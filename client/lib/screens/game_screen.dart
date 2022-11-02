import 'package:client/cubit/game_cubit.dart';
import 'package:client/components/node.dart';
import 'package:client/cubit/game_state.dart';
import 'package:client/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _GameView());
  }
}

class _GameView extends StatefulWidget {
  const _GameView({Key? key}) : super(key: key);

  @override
  State<_GameView> createState() => _GameViewState();
}

class _GameViewState extends State<_GameView> {
  // late ByteData animationFile;

  @override
  void initState() {
    super.initState();

    // loadFile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
        bloc: getIt<GameCubit>(),
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: ListView.builder(
                      itemCount: state.nodes.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) => Row(
                              children:
                                  List.generate(state.nodes[i].length, (j) {
                            return Node(
                                onTap: () {
                                  getIt<GameCubit>().tapNode(i, j);
                                },
                                value: state.nodes[i][j].isActive);
                          })))),
            ],
          );
        });
  }
}
