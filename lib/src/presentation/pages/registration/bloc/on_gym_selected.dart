import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onGymSelected(
  GymSelectedEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is GymNotSelectedState) {
    emit(
      GymSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        gyms: state.gyms,
        location: state.location,
        gym: event.gym,
      ),
    );
  } else if (state is GymSelectedState) {
    emit(
      GymSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        gyms: state.gyms,
        location: state.location,
        gym: event.gym,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
