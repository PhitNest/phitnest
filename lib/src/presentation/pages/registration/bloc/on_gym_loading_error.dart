import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onGymsLoadingError(
  GymsLoadingErrorEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is InitialState) {
    emit(
      GymsLoadingErrorState(
        firstNameConfirmed: state.firstNameConfirmed,
        failure: event.failure,
      ),
    );
  } else if (state is GymsLoadingErrorEvent) {
    emit(
      GymsLoadingErrorState(
        firstNameConfirmed: state.firstNameConfirmed,
        failure: event.failure,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
