import 'package:client/services/auth_service.dart';
import 'package:client/get_it.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:username_gen/username_gen.dart';

class RoomService {
  final _authService = getIt<AuthService>();

  Future<void> createRoom() async {
    var room = Room()
      ..title = UsernameGen().generate()
      ..creatorId = _authService.user!.objectId!
      ..participants = [_authService.user!.objectId!];
    // ..set('color',
    //     Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0))
    var response = await room.save();
    print(response.result);
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

  List<String>? get participants => get<List<String>>('participants');

  set participants(List<String>? participants) =>
      set<List<String>?>('participants', participants);
}
