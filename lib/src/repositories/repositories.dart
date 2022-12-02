import 'package:get_it/get_it.dart';

import 'repositories.dart';

export 'authentication/authentication_repository.dart';
export 'deviceCache/device_cache_repository.dart';
export 'environment/environment_repository.dart';
export 'location/location_repository.dart';
export 'gym/gym_repository.dart';
export 'user/user_repository.dart';
export 'memoryCache/memory_cache_repository.dart';

GetIt repositories = GetIt.instance;

inject() async {
  await DeviceCacheRepository.init();
  await EnvironmentRepository.init();
  repositories.registerSingleton(MemoryCacheRepository());
  repositories.registerSingleton(UserRepository());
  repositories.registerSingleton(GymRepository());
  repositories.registerSingleton(LocationRepository());
  repositories.registerSingleton(DeviceCacheRepository());
  repositories.registerSingleton(EnvironmentRepository());
  repositories.registerSingleton(AuthenticationRepository());
}
