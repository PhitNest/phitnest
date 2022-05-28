import 'dart:io';

import 'package:geolocator_platform_interface/src/models/position.dart';

import '../services.dart';

class AuthenticationServiceImpl extends AuthenticationService {
  @override
  Future<bool> isAuthenticated() {
    throw UnimplementedError();
  }

  @override
  Future<String?> loginWithApple(Position? locationData, String? ip) {
    throw UnimplementedError();
  }

  @override
  Future<String?> loginWithEmailAndPassword(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<String?> signupWithEmailAndPassword(
      String emailAddress,
      String password,
      File? profilePicture,
      String firstName,
      String lastName,
      String ip,
      Position? locationData,
      String mobile) {
    throw UnimplementedError();
  }
}
