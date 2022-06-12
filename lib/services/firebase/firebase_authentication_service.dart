import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:phitnest/constants/constants.dart';

import '../../models/models.dart';
import '../services.dart';

/// Firebase implementation of the authentication service.
class FirebaseAuthenticationService extends AuthenticationService {
  /// Instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String?> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required String ip,
      Location? locationData}) async {
    try {
      // Get the user credentials from firebase auth
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      User? firebaseUser = result.user;

      if (firebaseUser != null) {
        // Get the user model from the databaseService service
        userModel = await databaseService.getUserModel(firebaseUser.uid);

        // If the user returned is null, return an error message
        if (userModel != null) {
          userModel!.online = true;
          userModel!.lastOnlineTimestamp =
              DateTime.now().millisecondsSinceEpoch;
          userModel!.recentIP = ip;
          userModel!.recentLocation = locationData;
          userModel!.recentPlatform = Platform.operatingSystem;

          // Update the user model in the databaseService service
          return await databaseService.updateUserModel(userModel!);
        }
      }
    } on FirebaseAuthException catch (exception) {
      switch ((exception).code) {
        case 'invalid-email':
          return 'Email address is malformed.';
        case 'wrong-password':
          return 'Wrong password.';
        case 'user-not-found':
          return 'No user corresponding to the given email address.';
        case 'user-disabled':
          return 'This user has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts to sign in as this user.';
      }
    } catch (ignored) {}
    return 'Login failed';
  }

  Future<String?> registerWithEmailAndPassword(
      {required String emailAddress,
      required String password,
      required String firstName,
      required String lastName,
      required String ip,
      required String mobile,
      Location? locationData,
      File? profilePicture}) async {
    try {
      // Create credenetials with a given email/pass
      User? user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: emailAddress, password: password))
          .user;

      if (user != null) {
        // Create a new user model and initialize the current user
        userModel = UserModel(
          userId: user.uid,
          email: emailAddress,
          settings: UserSettings(
            profilePictureURL: DEFAULT_AVATAR_URL,
            notificationsEnabled: false,
            public: true,
            bio: '',
          ),
          online: true,
          mobile: mobile,
          firstName: firstName,
          lastName: lastName,
          signupIP: ip,
          recentIP: ip,
          lastOnlineTimestamp: DateTime.now().millisecondsSinceEpoch,
          signupLocation: locationData,
          recentLocation: locationData,
          recentPlatform: Platform.operatingSystem,
        );

        // Upload the profile picture
        if (profilePicture != null) {
          await storageService.uploadProfilePicture(userModel!, profilePicture);
          userModel!.settings.profilePictureURL =
              await storageService.getProfilePictureURL(userModel!);
        }

        // Update user model in databaseService service
        return await databaseService.updateUserModel(userModel!) == null
            ? null
            : 'Couldn\'t sign up for firebase, Please try again.';
      }
    } on FirebaseAuthException catch (error) {
      String message = 'Couldn\'t sign up';
      switch (error.code) {
        case 'email-already-in-use':
          message = 'Email already in use, Please pick another email!';
          break;
        case 'invalid-email':
          message = 'Enter valid e-mail';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          message = 'Password must be more than 5 characters';
          break;
        case 'too-many-requests':
          message = 'Too many requests, Please try again later.';
          break;
      }
      return message;
    } catch (e) {
      return 'Couldn\'t sign up';
    }
    return 'Sign up failed';
  }

  @override
  Future<bool> isAuthenticatedOrHasAuthCache() async {
    if (await super.isAuthenticatedOrHasAuthCache()) {
      return true;
    }

    String? uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      userModel = await databaseService.getUserModel(uid);
      if (userModel != null) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> signOut(String reason) async {
    await super.signOut(reason);
    await _firebaseAuth.signOut();
  }
}
