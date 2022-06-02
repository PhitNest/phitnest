import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

import '../../models/models.dart';
import '../../locator.dart';
import '../services.dart';

/// Firebase implementation of the authentication service.
class FirebaseAuthenticationService extends AuthenticationService {
  /// Instance of database service
  final DatabaseService _database = locator<DatabaseService>();

  /// Instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String?> signInWithApple(Position? locationData, String ip) async {
    // Request authorization from apple
    apple.AuthorizationResult appleAuth =
        await apple.TheAppleSignIn.performRequests([
      apple.AppleIdRequest(
          requestedScopes: [apple.Scope.email, apple.Scope.fullName])
    ]);

    // Return error if apple denies request
    if (appleAuth.error == null) {
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
            await _firebaseAuth.signInWithCredential(credential);

        User? firebaseUser = authResult.user;

        if (firebaseUser != null) {
          // Load the user model from database service using uid
          userModel = await _database.getUserModel(firebaseUser.uid);
          if (userModel != null) {
            userModel!.online = true;
            userModel!.lastOnlineTimestamp =
                DateTime.now().millisecondsSinceEpoch;
            userModel!.recentIP = ip;
            if (locationData != null) {
              userModel!.location = Location(
                  latitude: locationData.latitude,
                  longitude: locationData.longitude);
            }
          } else {
            Location? userLocation = locationData != null
                ? Location(
                    latitude: locationData.latitude,
                    longitude: locationData.longitude)
                : null;

            userModel = UserModel(
                signupIP: ip,
                email: appleIdCredential!.email ?? '',
                firstName: appleIdCredential.fullName?.givenName ?? 'Deleted',
                userID: firebaseUser.uid,
                lastName: appleIdCredential.fullName?.familyName ?? 'User',
                recentIP: ip,
                signupLocation: userLocation,
                location: userLocation,
                online: true);
          }

          // Update the database model
          return await _database.updateUserModel(userModel!);
        }
      }
    }
    // Return error
    return 'Couldn\'t login with apple.';
  }

  @override
  Future<String?> signInWithEmailAndPassword(
      String email, String password, Position? locationData, String ip) async {
    try {
      // Get the user credentials from firebase auth
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      User? firebaseUser = result.user;

      if (firebaseUser != null) {
        // Get the user model from the database service
        userModel = await _database.getUserModel(firebaseUser.uid);

        // If the user returned is null, return an error message
        if (userModel != null) {
          userModel!.online = true;
          userModel!.lastOnlineTimestamp =
              DateTime.now().millisecondsSinceEpoch;
          userModel!.recentIP = ip;
          if (locationData != null) {
            userModel!.location = Location(
                latitude: locationData.latitude,
                longitude: locationData.longitude);
          }

          // Update the user model in the database service
          return await _database.updateUserModel(userModel!);
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

  @override
  Future<String?> registerWithEmailAndPassword(
      String emailAddress,
      String password,
      File? profilePicture,
      String firstName,
      String lastName,
      Position? locationData,
      String ip,
      String mobile) async {
    try {
      // Create credenetials with a given email/pass
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: emailAddress, password: password);

      // Create a new user model and initialize the current user
      userModel = UserModel(
          email: emailAddress,
          settings:
              // Upload the profile picture to storage service before doing this
              UserSettings(profilePictureURL: profilePicture == null ? '' : ''),
          online: true,
          mobile: mobile,
          firstName: firstName,
          userID: result.user?.uid ?? '',
          lastName: lastName,
          signupIP: ip,
          recentIP: ip);

      // If the location is not null, set it
      if (locationData != null) {
        userModel!.signupLocation = Location(
            latitude: locationData.latitude, longitude: locationData.longitude);
      }

      // Update user model in database service
      return await _database.updateUserModel(userModel!) == null
          ? null
          : 'Couldn\'t sign up for firebase, Please try again.';
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
    if (await super.isAuthenticated()) {
      return true;
    }

    String? uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      userModel = await _database.getUserModel(uid);
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
