import 'dart:io';

import 'package:phitnest/models/user/user_model.dart';

import '../services.dart';

class StorageServiceImplementation extends StorageService {
  @override
  Future<void> uploadFile(String path, File file) {
    throw UnimplementedError();
  }

  @override
  Future<String> getFileURL(String path) {
    throw UnimplementedError();
  }

  @override
  Future<String> getProfilePictureURL(UserModel user) {
    throw UnimplementedError();
  }

  @override
  Future<void> uploadProfilePicture(UserModel user, File picture) {
    throw UnimplementedError();
  }
}
