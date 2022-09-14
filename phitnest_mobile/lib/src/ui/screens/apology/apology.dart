import 'package:flutter/material.dart';

import '../../../constants/routes.dart';
import '../screen.dart';
import 'apology_state.dart';
import 'apology_view.dart';

class ApologyScreen extends Screen<ApologyState, ApologyView> {
  @override
  ApologyView build(BuildContext context, ApologyState state) => ApologyView(
        onPressedContactUs: () => Navigator.pushNamedAndRemoveUntil(
            context, kContactUs, (_) => false),
        onPressedSubmit: () {},
      );

  @override
  ApologyState buildState() => ApologyState();
}
