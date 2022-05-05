import 'package:phitnest/locator.dart';
import 'package:phitnest/models/user_model.dart';
import 'package:phitnest/services/authentication_service.dart';
import 'package:phitnest/services/database_service.dart';

import '../../base_model.dart';

/// This is the view model for the home view.
class HomeModel extends BaseModel {
  Future<bool> updateLocation() async {
    UserModel? user = locator<AuthenticationService>().userModel;

    return user != null
        ? await locator<DatabaseService>().updateLocation(user)
        : false;
  }
}
