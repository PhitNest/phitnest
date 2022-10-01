import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../screen.dart';
import 'request_location_state.dart';
import 'request_location_view.dart';

class RequestLocationScreen
    extends Screen<RequestLocationState, RequestLocationView> {
  const RequestLocationScreen() : super();

  @override
  init(BuildContext context, RequestLocationState state) =>
      repositories<LocationRepository>().getLocation().then((response) =>
          response.fold(
              (location) => repositories<LocationRepository>()
                  .getNearestGym(location)
                  .then((gym) => gym != null
                      ? Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FoundLocationScreen(gym: gym)),
                          (_) => false)
                      : state.errorMessage = 'No nearby gyms could be found.'),
              (error) => state.errorMessage = error));

  @override
  RequestLocationView build(BuildContext context, RequestLocationState state) =>
      RequestLocationView(
        errorMessage: state.errorMessage ?? '',
        onPressedExit: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ApologyScreen()),
            (_) => false),
      );

  @override
  RequestLocationState buildState() => RequestLocationState();
}
