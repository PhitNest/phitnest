import 'package:get_it/get_it.dart';

import 'services/authentication_service.dart';
import 'services/database_service.dart';
import 'services/firebase_authentication_service.dart';
import 'services/firestore_database_service.dart';
import 'ui/screens/login/model/login_model.dart';
import 'ui/screens/onBoarding/provider/on_boarding_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AuthenticationService>(
      () => FirebaseAuthenticationService());
  locator
      .registerLazySingleton<DatabaseService>(() => FirestoreDatabaseService());

  locator.registerFactory(() => OnBoardingModel());
  locator.registerFactory(() => LoginModel());
}
