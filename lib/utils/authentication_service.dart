import 'dart:io';

import 'package:geolocator/geolocator.dart';

import '../../models/models.dart';

/// Abstract representation of the authentication service.
abstract class AuthenticationService {
  /// This is the current logged in user model.
  UserModel? userModel;

  /// Checks if the user is authenticated. If the user is authenticated but the
  /// model is not yet initialized, get [userModel] from the database service.
  Future<bool> isAuthenticated();

  /// Requests login service from apple, and initializes [userModel] with the
  /// result. Returns null if the login was successful, returns an error if the
  /// login fails.
  Future<String?> loginWithApple(Position? locationData, String? ip);

  /// Sends a login request to authentication and initializes [userModel]. If
  /// the login is successful, return null. Otherwise, return an error message.
  Future<String?> loginWithEmailAndPassword(String email, String password);

  /// Sends a sign up request to authentication and initializes [userModel]. If
  /// the registration is successful, return null. Otherwise, return an error
  /// message.
  Future<String?> signupWithEmailAndPassword(
      String emailAddress,
      String password,
      File? profilePicture,
      String firstName,
      String lastName,
      String ip,
      Position? locationData,
      String mobile);
}
