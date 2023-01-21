import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onRetakeProfilePicture(
  RetakeProfilePictureEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is GymSelectedState) {
    emit(
      GymSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        location: state.location,
        gyms: state.gyms,
        currentPage: state.currentPage,
        autovalidateMode: state.autovalidateMode,
        gym: state.gym,
        takenEmails: state.takenEmails,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
