import 'package:flutter/material.dart';

import '../../../constants/routes.dart';
import '../screen.dart';
import 'contact_us_state.dart';
import 'contact_us_view.dart';

class ContactUsScreen extends Screen<ContactUsState, ContactUsView> {
  @override
  ContactUsView build(BuildContext context, ContactUsState state) =>
      ContactUsView(
        nameController: state.nameController,
        emailController: state.emailController,
        feedbackController: state.feedbackController,
        onPressedExit: () {},
        onPressedSubmit: () => Navigator.pushNamedAndRemoveUntil(
            context, kThankYou, (_) => false,
            arguments: [state.nameController.text]),
      );

  @override
  ContactUsState buildState() => ContactUsState();
}
