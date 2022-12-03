import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';
import '../provider.dart';
import 'request_location_state.dart';
import 'request_location_view.dart';

class RequestLocationProvider
    extends ScreenProvider<RequestLocationState, RequestLocationView> {
  const RequestLocationProvider() : super();

  @override
  init(BuildContext context, RequestLocationState state) =>
      repositories<ILocationRepository>().getLocation().then(
            (response) => response.fold(
              (location) => repositories<IGymRepository>()
                  .getNearestGyms(
                    location: location,
                    distance: 30000,
                    amount: 1,
                  )
                  .then(
                    (gyms) => gyms.fold(
                      (gyms) => gyms.length > 0
                          ? Navigator.pushAndRemoveUntil(
                              context,
                              NoAnimationMaterialPageRoute(
                                builder: (context) => FoundLocationProvider(
                                  gym: gyms[0],
                                ),
                              ),
                              (_) => false)
                          : state.errorMessage =
                              'No nearby gyms could be found.',
                      (error) => state.errorMessage = error,
                    ),
                  ),
              (error) => state.errorMessage = error,
            ),
          );

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
