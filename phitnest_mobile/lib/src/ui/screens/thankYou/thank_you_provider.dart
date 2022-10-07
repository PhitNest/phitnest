import 'package:flutter/material.dart';

import '../login/login_provider.dart';
import '../provider.dart';
import 'thank_you_state.dart';
import 'thank_you_view.dart';

class ThankYouProvider extends ScreenProvider<ThankYouState, ThankYouView> {
  final String name;

  ThankYouProvider({required this.name}) : super();

  @override
  ThankYouView build(BuildContext context, ThankYouState state) => ThankYouView(
        onPressedBye: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginProvider()),
            (_) => false),
        name: name,
      );

  @override
  ThankYouState buildState() => ThankYouState();
}
