import 'package:get_it/get_it.dart';

import 'deviceCache/device_cache_repository.dart';
import 'environment/environment_repository.dart';
import 'location/location_repository.dart';

export 'deviceCache/device_cache_repository.dart';
export 'location/location_repository.dart';
export 'environment/environment_repository.dart';
export 'repository.dart';

GetIt repositories = GetIt.instance;

setup() {
  repositories.registerSingleton(LocationRepository());
  repositories.registerSingleton(DeviceCacheRepository());
  repositories.registerSingleton(EnvironmentRepository());
}
