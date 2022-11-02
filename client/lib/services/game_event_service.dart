import 'package:client/get_it.dart';
import 'package:client/services/auth_service.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

final LiveQuery liveQuery = LiveQuery();

class GameEventService {
  final _authService = getIt<AuthService>();

  late final Subscription subscription;

  String get _myUserId {
    return _authService.user!.objectId!;
  }

  initRoomEventsSubscription(roomId) async {
    QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(GameEvent())
      ..whereEqualTo('roomId', roomId)
      ..whereNotEqualTo('creatorId', _myUserId);
    subscription = await liveQuery.client.subscribe(query);
    return subscription;
  }

  disposeRoomEventsSubscription() {
    liveQuery.client.unSubscribe(subscription);
  }

  Future<GameEvent> create(roomId, x, y) async {
    var event = GameEvent()
      ..creatorId = _myUserId
      ..roomId = roomId
      ..x = x
      ..y = y;
    var response = await event.save();
    print(response.result);
    return event;
  }
}

class GameEvent extends ParseObject implements ParseCloneable {
  GameEvent() : super(keyTableName);

  GameEvent.clone() : this();

  @override
  clone(Map<String, dynamic> map) => GameEvent.clone()..fromJson(map);

  static const String keyTableName = 'GameEvent';

  int? get x => get<int?>('x');

  set x(int? x) => set<int?>('x', x);

  int? get y => get<int?>('y');

  set y(int? y) => set<int?>('y', y);

  String? get roomId => get<String?>('roomId');

  set roomId(String? roomId) => set<String?>('roomId', roomId);

  String? get creatorId => get<String?>('creatorId');

  set creatorId(String? creatorId) => set<String?>('creatorId', creatorId);
}
