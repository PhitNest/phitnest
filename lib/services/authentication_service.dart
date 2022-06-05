import 'dart:io';

import '../../models/models.dart';
import 'services.dart';

/// Abstract representation of the authentication service.
abstract class AuthenticationService {
  /// This is the current logged in user model.
  UserModel? userModel;

  /// Checks if the user is currently authenticated, or if the device has
  /// authentication credentials in its cache. If it does, sign in with those.
  /// Return whether or not the user is authenticated at the end of this method.
  Future<bool> isAuthenticatedOrHasAuthCache() async {
    return userModel != null;
  }

  /// Signs the user out of their account. Returns an error message if there
  /// was an error, or null if it was successful.
  Future<void> signOut(String reason) async {
    if (userModel != null) {
      userModel!.online = false;
      userModel!.lastOnlineTimestamp = DateTime.now().millisecondsSinceEpoch;
      await databaseService.updateUserModel(userModel!);
      userModel = null;
    }
  }

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
      Location? locationData,
      File? profilePicture});
}
