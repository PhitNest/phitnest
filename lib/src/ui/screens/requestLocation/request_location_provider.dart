import 'package:flutter/material.dart';

import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';
import '../provider.dart';
import 'request_location_state.dart';
import 'request_location_view.dart';

class RequestLocationProvider
    extends ScreenProvider<RequestLocationState, RequestLocationView> {
  @override
  Future<void> init(BuildContext context, RequestLocationState state) async {
    getLocationUseCase.get().then(
          (either) => either.fold(
            (location) => getNearestGymsUseCase
                .get(
                  location: location,
                  maxDistance: 30000,
                  limit: 1,
                )
                .then(
                  (gyms) => Navigator.pushAndRemoveUntil(
                    context,
                    NoAnimationMaterialPageRoute(
                      builder: (context) => FoundLocationProvider(
                        gym: gyms[0],
                      ),
                    ),
                    (_) => false,
                  ),
                ),
            (failure) => state.errorMessage = failure.message,
          ),
        );
  }

  const RequestLocationProvider() : super();

  @override
  RequestLocationView build(BuildContext context, RequestLocationState state) =>
      RequestLocationView(
        errorMessage: state.errorMessage ?? '',
        onPressedExit: () => Navigator.of(context).pushAndRemoveUntil(
          NoAnimationMaterialPageRoute(
            builder: (context) => ApologyProvider(),
          ),
          (_) => false,
        ),
      );

  @override
  RequestLocationState buildState() => RequestLocationState();
}
