import 'package:client/bloc/game_cubit/game_cubit.dart';
import 'package:get_it/get_it.dart';

import 'auth_service.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<GameCubit>(GameCubit());
  getIt.registerSingleton<AuthService>(AuthService());
}
