import 'package:client/services/auth_service.dart';
import 'package:client/get_it.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:username_gen/username_gen.dart';

class RoomService {
  final _authService = getIt<AuthService>();

  String get _myUserId {
    return _authService.user!.objectId!;
  }

  Future<Room> createRoom() async {
    var room = Room()
      ..title = UsernameGen().generate()
      ..creatorId = _myUserId
      ..participants = [_myUserId];
    // ..set('color',
    //     Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0))
    var response = await room.save();
    print(response.result);
    return room;
  }

  participateRoom(roomId) async {
    var updatedRoom = Room()..objectId = roomId..setAddUnique('participants', _myUserId);
    await updatedRoom.save();
  }

  exitRoom(roomId) async {
    var updatedRoom = Room()..objectId = roomId..setRemove('participants', _myUserId);
    await updatedRoom.save();
  }

  Future<Room> getRoom(String id) async {
    var response = await Room().getObject(id);
    return response.result;
  }
}

class Room extends ParseObject implements ParseCloneable {
  Room() : super(keyTableName);

  Room.clone() : this();

  @override
  clone(Map<String, dynamic> map) => Room.clone()..fromJson(map);

  static const String keyTableName = 'Room';

  String? get title => get<String?>('title');

  set title(String? title) => set<String?>('title', title);

  String? get creatorId => get<String?>('creatorId');

  set creatorId(String? creatorId) => set<String?>('creatorId', creatorId);

  List<dynamic>? get participants => get<List<dynamic>>('participants');

  set participants(List<dynamic>? participants) =>
      set<List<dynamic>?>('participants', participants);
}
