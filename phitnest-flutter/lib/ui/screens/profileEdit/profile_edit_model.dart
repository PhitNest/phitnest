import 'package:flutter/material.dart';

import '../screen_model.dart';

class ProfileEditModel extends ScreenModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
}
