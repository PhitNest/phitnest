import 'dart:io';

import 'package:geolocator_platform_interface/src/models/position.dart';

import '../services.dart';

class AuthenticationServiceImpl extends AuthenticationService {
  @override
  Future<bool> isAuthenticated() {
    throw UnimplementedError();
  }

  @override
  Future<String?> signInWithApple(Position? locationData, String ip) {
    throw UnimplementedError();
  }

  @override
  Future<String?> signInWithEmailAndPassword(
      String email, String password, Position? locationData, String ip) {
    throw UnimplementedError();
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
      String mobile) {
    throw UnimplementedError();
  }

  @override
  Future<String?> signOut(String reason) {
    throw UnimplementedError();
  }
}
