import 'package:flutter/src/widgets/framework.dart';

import '../screen.dart';
import 'apology_state.dart';
import 'apology_view.dart';

class ApologyScreen extends Screen<ApologyState, ApologyView> {
  @override
  ApologyView build(BuildContext context, ApologyState state) => ApologyView(
        onPressedContactUs: () {},
      );

  @override
  ApologyState buildState() => ApologyState();
}
