import 'dart:io';

import 'package:phitnest/models/models.dart';
import '../api.dart';

class RestAuthenticationApi extends AuthenticationApi {
  @override
  Future<String?> getAuthenticatedUid() {
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
      required DateTime birthday,
      Location? locationData,
      File? profilePicture}) {
    throw UnimplementedError();
  }

  @override
  Future<String?> signOut() {
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
