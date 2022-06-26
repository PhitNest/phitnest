import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../services.dart';

class FirebaseStorageService extends StorageService {
  Reference storage = FirebaseStorage.instance.ref();

  String profilePicturePath = 'profilePictures/';

  @override
  Future<void> uploadFile(String path, File file) async =>
      await (await storage.child(path).putFile(file).whenComplete(() {}));

  @override
  Future<String> getFileURL(String path) async =>
      await storage.child(path).getDownloadURL();

  @override
  Future<String> getProfilePictureURL() async =>
      await getFileURL('profilePictures/${authService.userModel?.userId}');

  @override
  Future<void> uploadProfilePicture(File picture) async => await uploadFile(
      'profilePictures/${authService.userModel?.userId}', picture);
}
