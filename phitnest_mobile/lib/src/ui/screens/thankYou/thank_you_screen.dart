import 'package:flutter/material.dart';

import '../screen.dart';
import 'thank_you_state.dart';
import 'thank_you_view.dart';

class ThankYouScreen extends Screen<ThankYouState, ThankYouView> {
  late final String name;

  ThankYouScreen({required this.name}) : super();

  @override
  ThankYouView build(BuildContext context, ThankYouState state) => ThankYouView(
        onPressedBye: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OnBoardingScreen()),
            (_) => false),
        name: name,
      );

  @override
  ThankYouState buildState() => ThankYouState();
}
