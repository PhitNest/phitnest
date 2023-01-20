import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onSetProfilePicture(
  SetProfilePictureEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  final gymSelectedState = state as GymSelectedState;
  emit(
    PhotoSelectedState(
      photo: event.image,
      firstNameConfirmed: state.firstNameConfirmed,
      location: gymSelectedState.location,
      gyms: gymSelectedState.gyms,
      currentPage: state.currentPage,
      autovalidateMode: state.autovalidateMode,
      gym: gymSelectedState.gym,
      takenEmails: state.takenEmails,
      gymConfirmed: gymSelectedState.gymConfirmed,
      cameraController: gymSelectedState.cameraController,
      hasReadPhotoInstructions: gymSelectedState.hasReadPhotoInstructions,
    ),
  );
}
