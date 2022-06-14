import 'dart:io';

import 'package:phitnest/models/models.dart';
import '../services.dart';

class AuthenticationServiceImpl extends AuthenticationService {
  @override
  Future<bool> isAuthenticatedOrHasAuthCache() {
    throw UnimplementedError();
  }

  @override
  Future<String?> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required String ip,
      Location? locationData}) {
    throw UnimplementedError();
  }

  @override
  Future<String?> registerWithEmailAndPassword(
      {required String emailAddress,
      required String password,
      required String firstName,
      required String lastName,
      required String ip,
      required String mobile,
      required String birthday,
      Location? locationData,
      File? profilePicture}) {
    throw UnimplementedError();
  }

  @override
  Future<String?> signOut(String reason) {
    throw UnimplementedError();
  }

  @override
  Future<String?> sendResetPasswordEmail(String email) {
    throw UnimplementedError();
  }

  @override
  Future<String?> sendMobileAuthRequest(String phoneNumber) {
    throw UnimplementedError();
  }
}
