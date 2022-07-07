import 'dart:io';

import '../api.dart';

class RestStorageApi extends StorageApi {
  @override
  Future<void> uploadFile(String path, File file) {
    throw UnimplementedError();
  }

  @override
  Future<String> getFileURL(String path) {
    throw UnimplementedError();
  }

  @override
  Future<String> getProfilePictureURL(String uid) {
    throw UnimplementedError();
  }

  @override
  Future<void> uploadProfilePicture(String uid, File picture) {
    throw UnimplementedError();
  }
}
