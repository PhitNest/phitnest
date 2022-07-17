import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:phitnest/constants/constants.dart';

import '../../models/models.dart';
import '../api.dart';

class FirebaseAuthenticationApiState extends AuthenticationApiState {}

/// Firebase implementation of the authentication api.
class FirebaseAuthenticationApi extends AuthenticationApi {
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
        // Get the user model from the social api
        AuthenticatedUser? user = await api<SocialApi>().refreshSignedInUser();

        // If the user returned is null, return an error message
        if (user != null) {
          user.online = true;
          user.lastOnlineTimestamp = DateTime.now();
          user.recentIp = ip;
          user.recentLocation = locationData;
          user.recentPlatform = Platform.operatingSystem;

          // Update the user model in the social api
          return await api<SocialApi>().updateUserModel(user);
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
  Future<String?> sendResetPasswordEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (except) {
      /// There are many different codes(hover over sendPasswordResetEmail or look up documentation for methods)
      // e.g. for auth/invalid-email the print statement will print: invalid-email
      return except.code;
    }

    return null;
  }

  @override
  Future<String?> sendMobileAuthRequest(String phoneNumber) async {
    try {
      // https://firebase.google.com/docs/auth/flutter/phone-auth
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (except) {
      /// There are many different codes(hover over sendPasswordResetEmail or look up documentation for methods)
      /// For now the code is printed to the console and returned false(back to screen to type in email for forgot password).
      // e.g. for auth/invalid-email the print statement will print: invalid-email in debug console(VS-Code)
      // print(except.code);
      return except.code;
    }
    //If password sucessfully sent, a redirect should happen in OnDone
    return null;
  }

  Future<String?> registerWithEmailAndPassword(
      {required String emailAddress,
      required String password,
      required String firstName,
      required String lastName,
      required String ip,
      required String mobile,
      required DateTime birthday,
      Location? locationData,
      File? profilePicture}) async {
    try {
      // Create credenetials with a given email/pass
      User? firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: emailAddress, password: password))
          .user;

      if (firebaseUser != null) {
        // Create a new user model and initialize the current user
        UserPublicInfo publicInfo = UserPublicInfo(
            userId: firebaseUser.uid,
            firstName: firstName,
            lastName: lastName,
            online: true,
            profilePictureUrl: kDefaultAvatarUrl,
            bio: '',
            lastOnlineTimestamp: DateTime.now());
        UserPrivateInfo privateInfo = UserPrivateInfo(
            email: emailAddress,
            mobile: mobile,
            birthday: birthday,
            notificationsEnabled: false,
            recentIp: ip,
            signupIp: ip,
            signupTimestamp: DateTime.now(),
            recentPlatform: Platform.operatingSystem,
            signupLocation: locationData,
            recentLocation: locationData);
        AuthenticatedUser user = AuthenticatedUser.fromInfo(
            publicInfo: publicInfo, privateInfo: privateInfo);

        // Upload the profile picture
        if (profilePicture != null) {
          await api<StorageApi>()
              .uploadProfilePicture(user.userId, profilePicture);
          user.profilePictureUrl =
              await api<StorageApi>().getProfilePictureURL(user.userId);
        }
        // Update user model in databaseService service
        return await api<SocialApi>().updateUserModel(user) == null
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
  Future<String?> getAuthenticatedUid() async {
    await _firebaseAuth.currentUser?.reload();

    return _firebaseAuth.currentUser?.uid;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  FirebaseAuthenticationApiState get initState =>
      FirebaseAuthenticationApiState();
}
