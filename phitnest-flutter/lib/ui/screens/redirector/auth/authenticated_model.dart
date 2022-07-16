import '../../../../models/models.dart';
import '../../screen_model.dart';

class AuthenticatedModel extends ScreenModel {
  AuthenticatedUser? _currentUser;

  AuthenticatedUser get currentUser => _currentUser!;

  set currentUser(AuthenticatedUser user) {
    _currentUser = user;
    notifyListeners();
  }
}
