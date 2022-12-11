import 'package:get_it/get_it.dart';

import 'implementations/implementations.dart';
import 'interfaces/interfaces.dart';

export 'interfaces/interfaces.dart';

final repositories = GetIt.instance;

void injectRepositories() {
  repositories.registerSingleton<IGymRepository>(GymRepository());
  repositories.registerSingleton<IAuthRepository>(AuthenticationRepository());
  repositories.registerSingleton<ILocationRepository>(LocationRepository());
  repositories
      .registerSingleton<IMemoryCacheRepository>(MemoryCacheRepository());
  repositories
      .registerSingleton<IDeviceCacheRepository>(DeviceCacheRepository());
  repositories.registerSingleton<IUserRepository>(UserRepository());
}

IGymRepository get gymRepo => repositories();
IAuthRepository get authRepo => repositories();
ILocationRepository get locationRepo => repositories();
IMemoryCacheRepository get memoryCacheRepo => repositories();
IDeviceCacheRepository get deviceCacheRepo => repositories();
IUserRepository get userRepo => repositories();
