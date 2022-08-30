import 'package:get_it/get_it.dart';
import 'package:phitnest_mobile/src/repositories/deviceCache/device_cache_repository.dart';

import 'location/location_repository.dart';

GetIt repositories = GetIt.instance;

setup() {
  repositories.registerSingleton(LocationRepository());
  repositories.registerSingleton(DeviceCacheRepository());
}
