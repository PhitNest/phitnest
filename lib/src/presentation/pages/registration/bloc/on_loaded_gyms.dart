import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onLoadedGyms(
  LoadedGymsEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is InitialState) {
    emit(
      GymNotSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        gyms: event.gyms,
        location: event.location,
        currentPage: state.currentPage,
        autovalidateMode: state.autovalidateMode,
      ),
    );
  } else if (state is GymsLoadingErrorState) {
    emit(
      GymNotSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        gyms: event.gyms,
        currentPage: state.currentPage,
        location: event.location,
        autovalidateMode: state.autovalidateMode,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
