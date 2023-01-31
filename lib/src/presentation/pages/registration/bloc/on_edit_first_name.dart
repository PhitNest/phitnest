import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/validators.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onEditFirstName(
  EditFirstNameEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  final validation = validateName(event.firstName);
  if (state is RegisterRequestErrorState) {
    emit(
      state.copyWith(
        firstNameConfirmed: validation == null,
      ),
    );
  } else if (state is RegisterRequestLoadingState) {
    emit(
      state.copyWith(
        firstNameConfirmed: validation == null,
      ),
    );
  } else if (state is GymSelectedState) {
    emit(
      state.copyWith(
        firstNameConfirmed: validation == null,
      ),
    );
  } else if (state is GymsLoadingState) {
    emit(
      state.copyWith(
        firstNameConfirmed: validation == null,
      ),
    );
  } else if (state is GymsLoadedState) {
    emit(
      state.copyWith(
        firstNameConfirmed: validation == null,
      ),
    );
  } else if (state is GymsLoadingErrorState) {
    emit(
      state.copyWith(
        firstNameConfirmed: validation == null,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
