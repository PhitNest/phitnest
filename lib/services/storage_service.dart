import 'dart:io';

import '../models/models.dart';

abstract class StorageService {
  Future<void> uploadFile(String path, File file);

  Future<String> getFileURL(String path);

  Future<void> uploadProfilePicture(UserModel user, File picture);

  Future<String> getProfilePictureURL(UserModel user);
}
