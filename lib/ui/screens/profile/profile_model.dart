import 'dart:io';

import '../screen_model.dart';

class ProfileModel extends ScreenModel {
  String profilePictureDownloadUrl = '';

  File? _profilePicture;

  File? get profilePicture => _profilePicture;

  set profilePicture(File? profilePicture) {
    _profilePicture = profilePicture;
    notifyListeners();
  }
}
