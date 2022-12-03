import 'package:get_it/get_it.dart';

import 'implementations/implementations.dart';
import 'interfaces/interfaces.dart';

export 'interfaces/interfaces.dart';

final repositories = GetIt.instance;

Future<void> setup() async {
  await EnvironmentRepository.init();
}

void injectRepositories() {
  repositories
      .registerSingleton<IEnvironmentRepository>(EnvironmentRepository());
  repositories.registerSingleton<IGymRepository>(GymRepository());
  repositories.registerSingleton<IAuthRepository>(AuthenticationRepository());
  repositories.registerSingleton<ILocationRepository>(LocationRepository());
  repositories
      .registerSingleton<IMemoryCacheRepository>(MemoryCacheRepository());
  repositories
      .registerSingleton<IDeviceCacheRepository>(DeviceCacheRepository());
}
