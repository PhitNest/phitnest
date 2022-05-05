import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

import '../../models/user_model.dart';
import '../../locator.dart';
import '../authentication_service.dart';
import '../database_service.dart';

class FirebaseAuthenticationService extends AuthenticationService {
  final DatabaseService _database = locator<DatabaseService>();

  /// Instance of firebase auth
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String?> loginWithApple(Position? position) async {
    // Request authorization from apple
    apple.AuthorizationResult appleAuth =
        await apple.TheAppleSignIn.performRequests([
      apple.AppleIdRequest(
          requestedScopes: [apple.Scope.email, apple.Scope.fullName])
    ]);

    // Return error if apple denies request
    if (appleAuth.error != null) {
      return 'Couldn\'t login with apple.';
    }

    // If authorized by apple
    if (appleAuth.status == apple.AuthorizationStatus.authorized) {
      // Auth request
      apple.AppleIdCredential? appleIdCredential = appleAuth.credential;

      // Get OAuth credential from auth request
      AuthCredential credential = OAuthProvider('apple.com').credential(
        accessToken:
            String.fromCharCodes(appleIdCredential?.authorizationCode ?? []),
        idToken: String.fromCharCodes(appleIdCredential?.identityToken ?? []),
      );

      // Pass the OAuth credential to firebase auth
      UserCredential authResult =
          await firebaseAuth.signInWithCredential(credential);

      // Load the user model from database service using uid
      userModel = await _database.getUserModel(authResult.user?.uid ?? '');

      if (userModel != null) {
        userModel!.online = true;
      } else {
        userModel = UserModel(
            email: appleIdCredential!.email ?? '',
            firstName: appleIdCredential.fullName?.givenName ?? 'Deleted',
            userID: authResult.user?.uid ?? '',
            lastName: appleIdCredential.fullName?.familyName ?? 'User',
            online: true,
            mobile: '',
            photos: [],
            settings: UserSettings());
      }

      // If position is not null, update the user position
      if (position != null) {
        userModel!.location = UserLocation(
            latitude: position.latitude, longitude: position.longitude);
      }

      // Update the database model
      return await _database.updateUserModel(userModel!);
    }

    // Return error
    return 'Couldn\'t login with apple.';
  }

  @override
  Future<String?> loginWithEmailAndPassword(
      String email, String password, Position? position) async {
    try {
      // Get the user credentials from firebase auth
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      // Get the user model from the database service
      userModel = await _database.getUserModel(result.user?.uid ?? '');

      // If the user returned is null, return an error message
      if (userModel == null) {
        return 'Login failed';
      }

      // If position is not null, save the current user position
      if (position != null) {
        userModel!.location = UserLocation(
            latitude: position.latitude, longitude: position.longitude);
      }

      // Update the user model in the database service
      return await _database.updateUserModel(userModel!);
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
      return 'Unexpected firebase error, Please try again.';
    } catch (e) {
      return 'Login failed, Please try again.';
    }
  }

  @override
  Future<String?> signupWithEmailAndPassword(
      String emailAddress,
      String password,
      File? profilePicture,
      String firstName,
      String lastName,
      Position locationData,
      String mobile) async {
    try {
      // Create credenetials with a given email/pass
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
          email: emailAddress, password: password);

      // Create a new user model and initialize the current user
      userModel = UserModel(
        email: emailAddress,
        signUpLocation: UserLocation(
            latitude: locationData.latitude, longitude: locationData.longitude),
        location: UserLocation(
            latitude: locationData.latitude, longitude: locationData.longitude),
        public: true,
        settings:
            // Upload the profile picture to storage service before doing this
            UserSettings(profilePictureURL: profilePicture == null ? '' : ''),
        school: '',
        photos: [],
        lastOnlineTimestamp: Timestamp.now(),
        bio: '',
        age: '',
        online: true,
        mobile: mobile,
        firstName: firstName,
        userID: result.user?.uid ?? '',
        lastName: lastName,
      );

      // Update user model in database service
      String? errorMessage = await _database.updateUserModel(userModel!);
      if (errorMessage == null) {
        return null;
      } else {
        return 'Couldn\'t sign up for firebase, Please try again.';
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
  }

  @override
  Future<bool> isAuthenticated() async {
    if (userModel != null) {
      return true;
    }

    String? uid = firebaseAuth.currentUser?.uid;
    if (uid != null) {
      userModel = await _database.getUserModel(uid);
      return true;
    } else {
      return false;
    }
  }
}
