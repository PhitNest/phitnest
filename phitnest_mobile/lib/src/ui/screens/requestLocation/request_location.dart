import 'package:flutter/material.dart';

import '../../../constants/routes.dart';
import '../screen.dart';
import 'request_location_state.dart';
import 'request_location_view.dart';

class RequestLocationScreen
    extends Screen<RequestLocationState, RequestLocationView> {
  const RequestLocationScreen() : super();

  @override
  Future<void> init(BuildContext context, RequestLocationState state) async {}

  @override
  RequestLocationView build(BuildContext context, RequestLocationState state) =>
      RequestLocationView(
        onPressedExit: () =>
            Navigator.pushNamedAndRemoveUntil(context, kApology, (_) => false),
      );

  @override
  RequestLocationState buildState() => RequestLocationState();
}
