import 'dart:async';

import '../model/User.dart';

class AuthenticationService {
  StreamController<User> _userController = StreamController<User>();

  Stream<User> get userStream => _userController.stream;

  Future<String?> updateCurrentUser(User user) async {
    _userController.add(user);
  }
}
