import 'dart:io';

import '../services.dart';

class StorageServiceImplementation extends StorageService {
  @override
  Future<String?> uploadProfilePicture(String userId, File profilePicture) {
    throw UnimplementedError();
  }

  @override
  Future<String?> getProfilePictureURL(String userId) {
    throw UnimplementedError();
  }
}
