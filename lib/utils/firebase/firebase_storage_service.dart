import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../services.dart';

class FirebaseStorageService extends StorageService {
  Reference storage = FirebaseStorage.instance.ref();

  String profilePicturePath = 'profilePictures/';

  @override
  Future<String?> uploadProfilePicture(
      String userId, File profilePicture) async {
    String filePath = '$profilePicturePath$userId';

    await (await storage
        .child(filePath)
        .putFile(profilePicture)
        .whenComplete(() {}));
    return filePath;
  }

  @override
  Future<String?> getProfilePictureURL(String userId) async =>
      await storage.child('$profilePicturePath$userId').getDownloadURL();
}
