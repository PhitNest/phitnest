import 'package:flutter/cupertino.dart';

import '../state.dart';

class RegisterPageOneState extends ScreenState {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}
