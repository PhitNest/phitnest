import 'package:flutter/material.dart';

import '../screens.dart';
import '../provider.dart';
import 'thank_you_state.dart';
import 'thank_you_view.dart';

class ThankYouProvider extends Provider<ThankYouState, ThankYouView> {
  final String name;

  ThankYouProvider({required this.name}) : super();

  @override
  ThankYouView build(BuildContext context, ThankYouState state) => ThankYouView(
        onPressedBye: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OnBoardingProvider()),
            (_) => false),
        name: name,
      );

  @override
  ThankYouState buildState() => ThankYouState();
}
