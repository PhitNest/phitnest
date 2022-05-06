import '../../../services/services.dart';
import '../../../models/models.dart';
import '../../../locator.dart';
import '../models.dart';

/// This is the view model for the home view.
class HomeModel extends BaseModel {
  Future<bool> updateLocation() async {
    UserModel? user = locator<AuthenticationService>().userModel;

    return user != null
        ? await locator<DatabaseService>().updateLocation(user)
        : false;
  }
}
