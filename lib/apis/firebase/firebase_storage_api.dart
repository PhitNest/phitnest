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
  Future<String> getFileURL(String path) async =>
      await storage.child(path).getDownloadURL();

  @override
  Future<String> getProfilePictureURL(String uid) async =>
      await getFileURL('$kProfilePictureBucketPath/$uid');

  @override
  Future<void> uploadProfilePicture(String uid, File picture) async =>
      await uploadFile('$kProfilePictureBucketPath/$uid', picture);
}
