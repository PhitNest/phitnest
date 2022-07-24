import 'dart:io';

import 'package:flutter/material.dart';

import '../screens.dart';

class ProfileViewModel extends AuthenticatedModel {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? _profilePicture;

  File? get profilePicture => _profilePicture;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  set profilePicture(File? profilePicture) {
    _profilePicture = profilePicture;
    notifyListeners();
  }
}
