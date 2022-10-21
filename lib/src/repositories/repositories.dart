import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'repositories.dart';

export 'authentication/authentication_repository.dart';
export 'deviceCache/device_cache_repository.dart';
export 'environment/environment_repository.dart';
export 'location/location_repository.dart';
export 'repository.dart';

GetIt repositories = GetIt.instance;
Future<SharedPreferences> _storage = SharedPreferences.getInstance();
SharedPreferences? storage;

setup() async {
  storage = await _storage;

  repositories.registerSingleton(LocationRepository());
  repositories.registerSingleton(DeviceCacheRepository());
  repositories.registerSingleton(EnvironmentRepository());
  repositories.registerSingleton(AuthenticationRepository());
}
