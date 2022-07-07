import 'dart:io';

import '../../models/models.dart';
import 'api.dart';

/// Abstract representation of the authentication service.
abstract class AuthenticationApi extends Api {
  /// Checks if the user is currently authenticated, If it does, return the
  /// authenticated uid.
  Future<String?> getAuthenticatedUid();

  Future<String?> sendMobileAuthRequest(String phoneNumber);

  Future<String?> sendResetPasswordEmail(String email);

  /// Signs the user out of their account. Returns an error message if there
  /// was an error, or null if it was successful.
  Future<void> signOut();

  /// Sends a login request to authentication and initializes [userModel]. If
  /// the login is successful, return null. Otherwise, return an error message.
  Future<String?> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required String ip,
      Location? locationData});

  /// Sends a sign up request to authentication and initializes [userModel]. If
  /// the registration is successful, return null. Otherwise, return an error
  /// message.
  Future<String?> registerWithEmailAndPassword(
      {required String emailAddress,
      required String password,
      required String firstName,
      required String lastName,
      required String ip,
      required String mobile,
      required DateTime birthday,
      Location? locationData,
      File? profilePicture});
}
