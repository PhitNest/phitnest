import 'dart:io';

import 'api.dart';

abstract class StorageApiState extends ApiState {}

abstract class StorageApi extends Api<StorageApiState> {
  Future<void> uploadFile(String path, File file);

  Future<String> getFileURL(String path);

  Future<void> uploadProfilePicture(String uid, File picture);

  Future<String> getProfilePictureURL(String uid);
}
