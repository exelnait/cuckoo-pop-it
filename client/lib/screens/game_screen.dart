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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _gameCubit.dispose().then(() {
      print('dispose');
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('dispose');
        await _gameCubit.dispose();
        return Future<bool>.value(true); // this will close the app,
      },
      child: BlocBuilder<GameCubit, GameState>(
          bloc: _gameCubit,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(state.title),
                ),
                Text('Participants: ${state.participants.length}'),
                SizedBox(height: 20),
                state.isStarted ? Center(
                    child: ListView.builder(
                        itemCount: state.nodes.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) => Row(
                                children: List.generate(
                              state.nodes[i].length,
                              (j) => Node(
                                  onTap: () {
                                    _gameCubit.tapNode(i, j);
                                  },
                                  value: state.nodes[i][j].isActive),
                            )))) : MaterialButton(child: Text('Start game'), onPressed: () {
                  _gameCubit.startGame();
                }),
              ],
            );
          }),
    );
  }
}
