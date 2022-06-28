import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../constants/constants.dart';
import '../services.dart';

class FirebaseStorageService extends StorageService {
  Reference storage = FirebaseStorage.instance.ref();

  @override
  Future<void> uploadFile(String path, File file) async =>
      await (await storage.child(path).putFile(file).whenComplete(() {}));

  @override
  Future<String> getFileURL(String path) async =>
      await storage.child(path).getDownloadURL();

  @override
  Future<String> getProfilePictureURL() async => await getFileURL(
      '$kProfilePictureBucketPath/${authService.userModel?.userId}');

  @override
  Future<void> uploadProfilePicture(File picture) async => await uploadFile(
      '$kProfilePictureBucketPath/${authService.userModel?.userId}', picture);
}
