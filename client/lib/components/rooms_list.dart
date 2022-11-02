import 'package:client/cubit/game_cubit.dart';
import 'package:client/get_it.dart';
import 'package:client/screens/game_screen.dart';
import 'package:client/services/room_service.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

final LiveQuery liveQuery = LiveQuery();
QueryBuilder<ParseObject> query =
    QueryBuilder<ParseObject>(ParseObject('Room'));

class RoomsList extends StatelessWidget {
  RoomsList({super.key});

  final _roomService = RoomService();

  createRoom(context) async {
    var room = await _roomService.createRoom();
    openGame(room.objectId, context);
  }

  openGame(roomId, context) async {
    await getIt<GameCubit>().init(roomId, 5, 5);
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const GameScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          MaterialButton(onPressed: () {
            createRoom(context);
          }, child: Text('Create game')),
          SizedBox(height: 20),
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
                  onTap:  () {
                    if (!snapshot.loadedData?.get("isStarted")) {
                      openGame(snapshot.loadedData?.objectId, context);
                    }
                  },
                  subtitle: Text(
                      '${snapshot.loadedData?.get("isStarted") ? 'Started. ': ''}Participants: ${snapshot.loadedData?.get("participants").length}'),
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
