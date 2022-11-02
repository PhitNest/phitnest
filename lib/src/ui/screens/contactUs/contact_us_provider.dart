import 'package:flutter/material.dart';

import '../../common/widgets.dart';
import '../screens.dart';
import '../provider.dart';
import 'contact_us_state.dart';
import 'contact_us_view.dart';

class ContactUsProvider extends ScreenProvider<ContactUsState, ContactUsView> {
  static const int kMaxFeedbackLength = 120;

  @override
  ContactUsView build(BuildContext context, ContactUsState state) =>
      ContactUsView(
        nameController: state.nameController,
        emailController: state.emailController,
        feedbackController: state.feedbackController,
        maxFeedbackLength: kMaxFeedbackLength,
        onPressedDoneEditing: () => state.feedbackFocus.unfocus(),
        onPressedExit: () {},
        onPressedSubmit: () => Navigator.pushAndRemoveUntil(
            context,
            NoAnimationMaterialPageRoute(
                builder: (_) =>
                    ThankYouProvider(name: state.nameController.text)),
            (_) => false),
      );

  @override
  ContactUsState buildState() => ContactUsState();
}
