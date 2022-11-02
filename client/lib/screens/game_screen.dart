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

  final _gameCubit = getIt<GameCubit>();

  // late ByteData animationFile;

  @override
  void initState() {
    super.initState();

    // loadFile();
  }

  // Future<void> loadFile() async {
  //   final ByteData data = await rootBundle.load('assets/rive/animation.riv');

  //   setState(() {
  //     animationFile = data;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(bloc: _gameCubit, builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Participants: ${state.participants.length}'),
          Center(
              child: ListView.builder(
                  itemCount: state.nodes.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) => Row(
                          children: List.generate(
                        state.nodes[i].length,
                        (j) => Node(
                            onTap: () {
                              print('node tapped');

                              print(i);
                              print(j);
                              _gameCubit.tapNode(i, j);
                            },
                            value: state.nodes[i][j].isActive ? 1 : 0),
                      )))),
        ],
      );
    });
  }

  @override
  void dispose() {
    _gameCubit.dispose().then(() {
      print('Game disposed');
    });
    super.dispose();
  }
}
