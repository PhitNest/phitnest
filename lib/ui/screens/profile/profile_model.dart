import 'dart:io';

import '../models.dart';

class ProfileModel extends BaseModel {
  String? profilePictureDownloadUrl;

  File? _profilePicture;

  File? get profilePicture => _profilePicture;

  set profilePicture(File? profilePicture) {
    _profilePicture = profilePicture;
    notifyListeners();
  }
}
