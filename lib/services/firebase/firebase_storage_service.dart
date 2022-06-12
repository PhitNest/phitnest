import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:phitnest/models/user/user_model.dart';

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
  Future<String> getProfilePictureURL(UserModel user) async =>
      await getFileURL('profilePictures/${user.userId}');

  @override
  Future<void> uploadProfilePicture(UserModel user, File picture) async =>
      await uploadFile('profilePictures/${user.userId}', picture);
}
