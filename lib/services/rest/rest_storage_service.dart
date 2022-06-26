import 'dart:io';

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
  Future<String> getProfilePictureURL() {
    throw UnimplementedError();
  }

  @override
  Future<void> uploadProfilePicture(File picture) {
    throw UnimplementedError();
  }
}
