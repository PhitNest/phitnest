import 'package:flutter/material.dart';

import '../../../constants/routes.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../screen.dart';
import 'request_location_state.dart';
import 'request_location_view.dart';

class RequestLocationScreen
    extends Screen<RequestLocationState, RequestLocationView> {
  const RequestLocationScreen() : super();

  @override
  Future<void> init(BuildContext context, RequestLocationState state) async {
    state.serviceStatusListener = repositories<LocationRepository>()
        .streamServiceStatus()
        .listen((permissionsUpdate) => repositories<LocationRepository>()
                .getLocation()
                .then((response) async {
              if (response.isLeft()) {
                Navigator.pushNamedAndRemoveUntil(
                    context, kFoundLocation, (_) => false, arguments: [
                  await repositories<LocationRepository>()
                      .getNearestGym(response as Location)
                ]);
              }
            }));
  }

  @override
  RequestLocationView build(BuildContext context, RequestLocationState state) =>
      RequestLocationView(
        onPressedExit: () =>
            Navigator.pushNamedAndRemoveUntil(context, kApology, (_) => false),
      );

  @override
  RequestLocationState buildState() => RequestLocationState();
}
