import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/widgets/widgets.dart';
import '../screen_model.dart';

class ProfileEditModel extends ScreenModel {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? _profilePicture;

  File? get profilePicture => _profilePicture;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  DateEditingController birthdayController = DateEditingController();

  set profilePicture(File? profilePicture) {
    _profilePicture = profilePicture;
    notifyListeners();
  }
}
