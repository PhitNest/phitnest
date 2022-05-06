import '../../../services/services.dart';
import '../../../models/models.dart';
import '../../../locator.dart';
import '../models.dart';

/// This is the view model for the home view.
class HomeModel extends BaseModel {
  final AuthenticationService _authService = locator<AuthenticationService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  Future<bool> updateLocation() async {
    UserModel? user = _authService.userModel;

    return user != null ? await _databaseService.updateLocation(user) : false;
  }
}
