import 'dart:math';

import 'package:client/auth_service.dart';
import 'package:client/bloc/game_cubit/game_cubit.dart';
import 'package:client/extentions.dart';
import 'package:client/get_it.dart';
import 'package:client/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:username_gen/username_gen.dart';

final LiveQuery liveQuery = LiveQuery();
QueryBuilder<ParseObject> query =
    QueryBuilder<ParseObject>(ParseObject('Room'));

class RoomsList extends StatelessWidget {
  const RoomsList({super.key});

  createRoom() async {
    var currentUser = getIt<AuthService>().user!;
    var room = ParseObject('Room')
      ..set('title', UsernameGen().generate())
      ..set('creatorId', currentUser.objectId)
      // ..set('color',
      //     Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0))
      ..setAddUnique('participants', currentUser.objectId);
    await room.save();
  }

  openGame(context) {
    getIt<GameCubit>().init(5, 5);
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const GameScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          MaterialButton(onPressed: createRoom, child: Text('Create room')),
          ParseLiveListWidget<ParseObject>(
            shrinkWrap: true,
            query: query,
            reverse: false,
            childBuilder: (BuildContext context,
                ParseLiveListElementSnapshot<ParseObject> snapshot) {
              if (snapshot.failed) {
                return const Text('something went wrong!');
              } else if (snapshot.hasData) {
                print(snapshot.loadedData);
                return ListTile(
                  // leading: Container(
                  //   decoration: BoxDecoration(
                  //       color:
                  //           HexColor.fromHex(snapshot.loadedData?.get('color')),
                  //       shape: BoxShape.circle),
                  // ),
                  dense: true,
                  title: Text(
                    snapshot.loadedData?.get("title"),
                  ),
                  onTap: () => openGame(context),
                  subtitle: Text(
                      'Participants: ${snapshot.loadedData?.get("participants").length}'),
                );
              } else {
                return const ListTile(
                  leading: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
