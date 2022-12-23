import 'package:flutter/material.dart';
import 'package:phitnest_mobile/src/ui/screens/foundLocation/found_location_provider.dart';

import '../../../entities/entities.dart';
import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import 'request_location_state.dart';
import 'request_location_view.dart';

class RequestLocationProvider
    extends ScreenProvider<RequestLocationCubit, RequestLocationState> {
  final Future<void> Function(GymEntity gym) onFoundNearestGym;

  const RequestLocationProvider({
    required this.onFoundNearestGym,
  }) : super();

  @override
  RequestLocationCubit buildCubit() => RequestLocationCubit();

  @override
  Future<void> listener(
    BuildContext context,
    RequestLocationCubit cubit,
    RequestLocationState state,
  ) async {
    if (state is FetchingLocationState) {
      getLocationUseCase.get().then(
            (either) => either.fold(
              (location) => cubit.transitionToFetchingGym(location),
              (failure) => cubit.transitionToError(failure.message),
            ),
          );
    } else if (state is FetchingGymState) {
      getNearestGymsUseCase
          .get(location: state.location, maxDistance: 30000, limit: 1)
          .then(
            (either) => either.fold(
              (gyms) {
                if (gyms.length > 0) {
                  Navigator.of(context)
                    ..pop()
                    ..push(
                      NoAnimationMaterialPageRoute(
                        builder: (context) => FoundLocationProvider(
                          gym: gyms.first,
                          location: state.location,
                          onFoundNearestGym: onFoundNearestGym,
                        ),
                      ),
                    );
                } else {
                  cubit.transitionToError("No gyms found.");
                }
              },
              (failure) => cubit.transitionToError(failure.message),
            ),
          );
    }
  }

  @override
  Widget builder(
    BuildContext context,
    RequestLocationCubit cubit,
    RequestLocationState state,
  ) {
    if (state is FetchingLocationState) {
      return FetchingLocationView();
    } else if (state is FetchingGymState) {
      return FetchingGymView();
    } else if (state is ErrorState) {
      return ErrorView(
        errorMessage: state.message,
        onPressedRetry: () => cubit.transitionToFetchingLocation(),
      );
    } else {
      throw Exception('Unknown state: $state');
    }
  }
}
