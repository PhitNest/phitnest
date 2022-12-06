import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';
import '../provider.dart';
import 'request_location_state.dart';
import 'request_location_view.dart';

class RequestLocationProvider
    extends ScreenProvider<RequestLocationState, RequestLocationView> {
  const RequestLocationProvider() : super();

  @override
  RequestLocationView build(BuildContext context, RequestLocationState state) =>
      RequestLocationView(
        errorMessage: state.errorMessage ?? '',
        onPressedSkip: () => Navigator.of(context).pushAndRemoveUntil(
            NoAnimationMaterialPageRoute(
              builder: (context) => FoundLocationProvider(
                gym: new GymEntity(
                  id: "1",
                  name: "Planet Fitness",
                  address: new AddressEntity(
                    street: "123 Street st",
                    city: "Virginia Beach",
                    state: "VA",
                    zipCode: "23456",
                  ),
                  location: new LocationEntity(
                    longitude: 52,
                    latitude: -20,
                  ),
                ),
              ),
            ),
            (route) => false),
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
