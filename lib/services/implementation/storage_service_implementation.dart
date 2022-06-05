import 'dart:io';

import '../services.dart';

class StorageServiceImplementation extends StorageService {
  @override
  Future<String?> uploadProfilePicture(String userId, File? profilePicture) {
    throw UnimplementedError();
  }

  @override
  Future<File?> getProfilePicture(String userId) {
    throw UnimplementedError();
  }
}
