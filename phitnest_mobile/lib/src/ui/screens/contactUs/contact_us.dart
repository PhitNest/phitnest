import 'package:flutter/material.dart';

import '../../../routes.dart';
import '../screen.dart';
import 'contact_us_state.dart';
import 'contact_us_view.dart';

class ContactUsScreen extends Screen<ContactUsState, ContactUsView> {
  static const int kMaxFeedbackLength = 120;

  @override
  ContactUsView build(BuildContext context, ContactUsState state) =>
      ContactUsView(
        nameController: state.nameController,
        emailController: state.emailController,
        feedbackController: state.feedbackController,
        maxFeedbackLength: kMaxFeedbackLength,
        onPressedExit: () {},
        onPressedSubmit: () => Navigator.pushNamedAndRemoveUntil(
            context, kThankYou, (_) => false,
            arguments: [state.nameController.text]),
      );

  @override
  ContactUsState buildState() => ContactUsState();
}
