import 'dart:io';

import '../../models/models.dart';
import 'api.dart';

abstract class AuthenticationApiState extends ApiState {}

/// Abstract representation of the authentication api.
abstract class AuthenticationApi extends Api<AuthenticationApiState> {
  /// Checks if the user is currently authenticated, If they are, return the
  /// authenticated uid.
  Future<String?> getAuthenticatedUid();

  Future<String?> sendMobileAuthRequest(String phoneNumber);

  Future<String?> sendResetPasswordEmail(String email);

  /// Signs the user out of their account.
  Future<void> signOut();

  /// Sends a login request to authentication. If the login is unsuccessful,
  /// return an error message.
  Future<String?> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required String ip,
      Location? locationData});

  /// Sends a registration request to authentication. If successful, the user
  /// is authenticated and returns null. Otherwise, return an error message.
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
