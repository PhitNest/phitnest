import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../../common/widgets.dart';
import '../screens.dart';
import '../provider.dart';
import 'request_location_state.dart';
import 'request_location_view.dart';

class RequestLocationProvider
    extends ScreenProvider<RequestLocationState, RequestLocationView> {
  const RequestLocationProvider() : super();

  @override
  init(BuildContext context, RequestLocationState state) =>
      repositories<LocationRepository>().getLocation().then((response) =>
          response.fold(
              (location) => repositories<LocationRepository>()
                      .getNearestGym(location)
                      .then((gym) {
                    try {
                      return gym != null
                          ? Navigator.pushAndRemoveUntil(
                              context,
                              NoAnimationMaterialPageRoute(
                                  builder: (context) =>
                                      FoundLocationProvider(gym: gym)),
                              (_) => false)
                          : state.errorMessage =
                              'No nearby gyms could be found.';
                    } catch (ignore) {}
                  }),
              (error) => state.errorMessage = error));

  @override
  RequestLocationView build(BuildContext context, RequestLocationState state) =>
      RequestLocationView(
        errorMessage: state.errorMessage ?? '',
        onPressedExit: () => Navigator.pushAndRemoveUntil(
            context,
            NoAnimationMaterialPageRoute(
                builder: (context) => ApologyProvider()),
            (_) => false),
      );

  @override
  RequestLocationState buildState() => RequestLocationState();
}
