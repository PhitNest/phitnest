import 'dart:io';

import '../base_model.dart';

class ProfileModel extends BaseModel {
  String profilePictureDownloadUrl = '';

  File? _profilePicture;

  File? get profilePicture => _profilePicture;

  set profilePicture(File? profilePicture) {
    _profilePicture = profilePicture;
    notifyListeners();
  }
}
