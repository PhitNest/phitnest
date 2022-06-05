import 'dart:io';

abstract class StorageService {
  File? profilePictureCache;

  /// Returns null if the photo could not be uploaded, otherwise returns the
  /// URL of the uploaded picture.
  Future<String?> uploadProfilePicture(String userId, File profilePicture);

  Future<String?> getProfilePictureURL(String userId);
}
