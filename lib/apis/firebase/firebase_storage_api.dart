import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../constants/constants.dart';
import '../api.dart';

class FirebaseStorageApi extends StorageApi {
  Reference storage = FirebaseStorage.instance.ref();

  @override
  Future<void> uploadFile(String path, File file) async =>
      await (await storage.child(path).putFile(file).whenComplete(() {}));

  @override
  Future<String> getFileURL(String path) =>
      storage.child(path).getDownloadURL();

  @override
  Future<String> getProfilePictureURL(String uid) =>
      getFileURL('$kProfilePictureBucketPath/$uid');

  @override
  Future<void> uploadProfilePicture(String uid, File picture) =>
      uploadFile('$kProfilePictureBucketPath/$uid', picture);
}
