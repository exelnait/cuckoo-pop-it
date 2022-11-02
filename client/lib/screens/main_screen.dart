import 'package:client/bloc/game_cubit/game_cubit.dart';
import 'package:client/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

final LiveQuery liveQuery = LiveQuery();
QueryBuilder<ParseObject> query =
    QueryBuilder<ParseObject>(ParseObject('Room'));

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    Subscription subscription = await liveQuery.client.subscribe(query);
    subscription.on(LiveQueryEvent.create, (value) {
      print('*** CREATE ***: ${DateTime.now().toString()}\n $value ');
      print((value as ParseObject).objectId);
      print((value as ParseObject).updatedAt);
      print((value as ParseObject).createdAt);
    });
  }

  createEvent() async {
    var room = ParseObject('Room')..set('Name', 'Test');
    await room.save();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
            child: const Text('Create room'), onPressed: createEvent),
        MaterialButton(
            child: const Text('Game screen'),
            onPressed: () {
              context.read<GameCubit>().init(5, 5);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const GameScreen()));
            })
      ],
    ));
  }
}
