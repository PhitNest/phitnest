import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/widgets/widgets.dart';
import '../screens.dart';

class ProfileEditModel extends AuthenticatedModel {
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
