import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';
import '../provider.dart';
import 'request_location_state.dart';
import 'request_location_view.dart';

class RequestLocationProvider
    extends ScreenProvider<RequestLocationState, RequestLocationView> {
  final void Function(
    BuildContext context,
    LocationEntity location,
    GymEntity gym,
  ) onFoundUsersGym;

  const RequestLocationProvider({
    required this.onFoundUsersGym,
  }) : super();

  @override
  Future<void> init(BuildContext context, RequestLocationState state) async {
    state.errorMessage = null;
    state.searching = true;
    getLocationUseCase.get().then(
          (either) => either.fold(
            (location) {
              if (state.disposed) return;
              getNearestGymsUseCase
                  .get(
                    location: location,
                    maxDistance: 30000,
                    limit: 1,
                  )
                  .then(
                    (either) => either.fold(
                      (gyms) => gyms.length > 0
                          ? {
                              if (!state.disposed)
                                {
                                  Navigator.push(
                                    context,
                                    NoAnimationMaterialPageRoute(
                                      builder: (context) =>
                                          FoundLocationProvider(
                                        gym: gyms[0],
                                        userLocation: location,
                                        onFoundUsersGym: onFoundUsersGym,
                                      ),
                                    ),
                                  )
                                }
                            }
                          : {
                              state.searching = false,
                              state.errorMessage = 'No gyms found',
                            },
                      (failure) => onFailure(failure, state),
                    ),
                  );
            },
            (failure) => onFailure(failure, state),
          ),
        );
  }

  void onFailure(Failure failure, RequestLocationState state) {
    state.searching = false;
    state.errorMessage = failure.message;
  }

  @override
  RequestLocationView build(BuildContext context, RequestLocationState state) =>
      RequestLocationView(
        errorMessage: state.errorMessage,
        searching: state.searching,
        onPressRetry: () => init(context, state),
      );

  @override
  RequestLocationState buildState() => RequestLocationState();
}
