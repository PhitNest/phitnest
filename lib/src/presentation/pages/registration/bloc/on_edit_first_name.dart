import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/validators.dart';
import '../event/edit_first_name.dart';
import '../state/registration_state.dart';

void onEditFirstName(
  EditFirstNameEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is InitialState) {
    emit(
      InitialState(
        firstNameConfirmed: validateName(event.firstName) == null,
        loadGymsOp: state.loadGymsOp,
      ),
    );
  } else if (state is GymNotSelectedState) {
    emit(
      GymNotSelectedState(
        firstNameConfirmed: validateName(event.firstName) == null,
        gyms: state.gyms,
        location: state.location,
      ),
    );
  } else if (state is GymsLoadingErrorState) {
    emit(
      GymsLoadingErrorState(
        firstNameConfirmed: validateName(event.firstName) == null,
        failure: state.failure,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
