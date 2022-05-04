import 'package:get_it/get_it.dart';

import 'services/services.dart';
import 'services/firebase/firebase_service.dart';
import 'ui/views/models.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AuthenticationService>(
      () => FirebaseAuthenticationService());
  locator
      .registerLazySingleton<DatabaseService>(() => FirestoreDatabaseService());

  locator.registerFactory(() => OnBoardingModel());
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => SignupModel());
}
