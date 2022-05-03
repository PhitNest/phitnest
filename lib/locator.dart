import 'package:get_it/get_it.dart';
import 'package:phitnest/ui/screens/auth/provider/auth_model.dart';
import 'package:phitnest/ui/screens/onBoarding/provider/on_boarding_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => OnBoardingModel());
  locator.registerFactory(() => AuthModel());
}
