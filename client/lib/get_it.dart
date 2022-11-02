import 'package:client/cubit/game_cubit.dart';
import 'package:client/services/room_service.dart';
import 'package:get_it/get_it.dart';

import 'services/auth_service.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<GameCubit>(() => GameCubit());

  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<RoomService>(() => RoomService());
}
