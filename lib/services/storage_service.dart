import 'dart:io';

abstract class StorageService {
  Future<void> uploadFile(String path, File file);

  Future<String> getFileURL(String path);

  Future<void> uploadProfilePicture(File picture);

  Future<String> getProfilePictureURL();
}
