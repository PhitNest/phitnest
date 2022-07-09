import 'dart:io';

import '../screens.dart';

class ProfileModel extends AuthenticatedModel {
  File? _profilePicture;

  File? get profilePicture => _profilePicture;

  set profilePicture(File? profilePicture) {
    _profilePicture = profilePicture;
    notifyListeners();
  }
}
