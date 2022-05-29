import 'package:get_it/get_it.dart';

import 'ui/screens/models.dart';
import 'services/firebase/firebase_service.dart';
import 'services/services.dart';

/// This provides access to all of our services, and factory constructors for
/// UI state
GetIt locator = GetIt.instance;

void setupLocator() {
  // Register each service (Only one instance of each)
  locator.registerLazySingleton<AuthenticationService>(
      () => FirebaseAuthenticationService());
  locator
      .registerLazySingleton<DatabaseService>(() => FirestoreDatabaseService());

  // Register each UI view model
  locator.registerFactory(() => OnBoardingModel());
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => SignupModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => ProfileModel());
  locator.registerFactory(() => AuthModel());
}
