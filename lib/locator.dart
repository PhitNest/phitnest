import 'package:get_it/get_it.dart';
import 'package:phitnest/ui/screens/login/model/login_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory<LoginModel>(() => LoginModel());
}
