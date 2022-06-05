import 'dart:io';

import '../services.dart';

class FirebaseStorageService extends StorageService {
  @override
  Future<String?> uploadProfilePicture(
      String userId, File? profilePicture) async {
    return '';
  }

  @override
  Future<File?> getProfilePicture(String userId) async {
    return null;
  }
}
