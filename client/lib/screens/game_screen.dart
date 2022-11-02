import 'package:client/components/node.dart';
import 'package:client/cubit/game_cubit.dart';
import 'package:client/cubit/game_state.dart';
import 'package:client/get_it.dart';
import 'package:client/screens/finish_screen.dart';
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
      child: BlocConsumer<GameCubit, GameState>(
          listenWhen: (previous, current) =>
              previous.isFinished != current.isFinished,
          listener: (context, state) {
            if (state.isFinished) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const FinishScreen()));
            }
          },
          bloc: _gameCubit,
          builder: (context, state) {
            print(state.participants);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text(state.title, style: const TextStyle(fontSize: 20)),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Participants: ${state.participants.length}'),
                    Column(
                        children: state.participants.entries
                            .map((participant) => Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Chip(
                                    label: Text(
                                      participant.value.name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: participant.value.color)))
                            .toList()),
                    const SizedBox(height: 2),
                    Text('Time: ${state.timerValue}')
                  ],
                ),
                SizedBox(height: 20),
                state.isStarted
                    ? Center(
                        child: ListView.builder(
                            itemCount: state.nodes.length,
                            shrinkWrap: true,
                            itemBuilder: (context, i) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  state.nodes[i].length,
                                  (j) => Node(
                                      color: state
                                          .participants[
                                              state.nodes[i][j].userId]
                                          ?.color,
                                      onTap: () {
                                        _gameCubit.tapNode(i, j);
                                      },
                                      value: state.nodes[i][j].isActive),
                                ))))
                    : Center(
                        child: MaterialButton(
                            child: Text('Start game'),
                            onPressed: () {
                              _gameCubit.startGame();
                            }),
                      ),
              ],
            );
          }),
    );
  }
}
