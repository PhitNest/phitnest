import 'dart:io';

import 'package:geolocator/geolocator.dart';

import '../../models/models.dart';

/// Abstract representation of the authentication service.
abstract class AuthenticationService {
  /// This is the current logged in user model.
  UserModel? userModel;

  /// Checks if the user is authenticated. If the user is authenticated but the
  /// [userModel] is not yet initialized, initialize [userModel] through the
  /// database service. Return true if the user was authenticated.
  Future<bool> isAuthenticated() async {
    return userModel != null;
  }

  /// Signs the user out of their account. Returns an error message if there
  /// was an error, or null if it was successful.
  Future<void> signOut(String reason) async {
    if (userModel != null) {
      userModel!.online = false;
      userModel!.lastOnlineTimestamp = DateTime.now().millisecondsSinceEpoch;
      userModel = null;
    }
  }

  /// Requests login service from apple, and initializes [userModel] with the
  /// result. Returns null if the login was successful, returns an error if the
  /// login fails.
  Future<String?> signInWithApple(Position? locationData, String ip);

  /// Sends a login request to authentication and initializes [userModel]. If
  /// the login is successful, return null. Otherwise, return an error message.
  Future<String?> signInWithEmailAndPassword(
      String email, String password, Position? locationData, String ip);

  /// Sends a sign up request to authentication and initializes [userModel]. If
  /// the registration is successful, return null. Otherwise, return an error
  /// message.
  Future<String?> registerWithEmailAndPassword(
      String emailAddress,
      String password,
      File? profilePicture,
      String firstName,
      String lastName,
      Position? locationData,
      String ip,
      String mobile);
}
