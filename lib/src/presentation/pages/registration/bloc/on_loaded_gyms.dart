import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onLoadedGyms(LoadedGymsEvent event, Emitter<RegistrationState> emit,
    RegistrationState state) {
  if (state is InitialState) {
    emit(
      GymNotSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        gyms: event.gyms,
        location: event.location,
      ),
    );
  } else if (state is GymsLoadingErrorEvent) {
    emit(
      GymNotSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        gyms: event.gyms,
        location: event.location,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
