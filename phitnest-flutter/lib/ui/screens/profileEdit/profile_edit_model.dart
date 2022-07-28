import 'package:flutter/material.dart';

import '../screen_model.dart';

class ProfileEditModel extends ScreenModel {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
}
