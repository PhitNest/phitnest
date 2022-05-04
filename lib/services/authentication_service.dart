import 'package:geolocator/geolocator.dart';

import '../models/user_model.dart';

abstract class AuthenticationService {
  /// This is the current logged in user model.
  UserModel? userModel;

  /// Requests login service from apple, and initializes [userModel] with the
  /// result. Returns null if the login was successful, returns an error if the
  /// login fails.
  Future<String?> loginWithApple(Position? position);

  /// Sends a login request to authentication and initializes [userModel]. If
  /// the login is successful, return null. Otherwise, return an error message.
  Future<String?> loginWithEmailAndPassword(
      String email, String password, Position? position);
}
