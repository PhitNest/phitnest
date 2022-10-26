import 'package:flutter/material.dart';

import '../state.dart';

import 'contact_us_provider.dart';
import 'contact_us_view.dart';

/**
 * Holds the dynamic content of [ContactUsProvider]. Calls to [rebuildView] will rebuild 
 * the [ContactUsView].
 */
class ContactUsState extends ScreenState {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    feedbackController.dispose();
    super.dispose();
  }
}
