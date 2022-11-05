import 'package:flutter/material.dart';
import '../state.dart';

class ForgotPasswordState extends ScreenState {
  final TextEditingController emailAddressController = TextEditingController();

  @override
  void dispose() {
    emailAddressController.dispose();
    super.dispose();
  }
}
