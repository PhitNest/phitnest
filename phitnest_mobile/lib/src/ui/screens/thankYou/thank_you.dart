import 'package:flutter/material.dart';

import '../../../routes.dart';
import '../screen.dart';
import 'thank_you_state.dart';
import 'thank_you_view.dart';

class ThankYouScreen extends Screen<ThankYouState, ThankYouView> {
  final String name;

  const ThankYouScreen({required this.name}) : super();

  @override
  ThankYouView build(BuildContext context, ThankYouState state) => ThankYouView(
        onPressedBye: () => Navigator.pushNamedAndRemoveUntil(
            context, kOnBoarding, (_) => false),
        name: name,
      );

  @override
  ThankYouState buildState() => ThankYouState();
}
