import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onReadPhotoInstructions(
  ReadPhotoInstructionsEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) async {
  if (state is RegisterErrorState) {
    emit(
      RegisterErrorState(
        autovalidateMode: state.autovalidateMode,
        gym: state.gym,
        gyms: state.gyms,
        gymConfirmed: state.gymConfirmed,
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
        takenEmails: state.takenEmails,
        location: state.location,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: true,
        photo: state.photo,
        failure: state.failure,
      ),
    );
  } else if (state is RegisteringState) {
    emit(
      RegisteringState(
        autovalidateMode: state.autovalidateMode,
        gym: state.gym,
        gyms: state.gyms,
        gymConfirmed: state.gymConfirmed,
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
        location: state.location,
        cameraController: state.cameraController,
        takenEmails: state.takenEmails,
        hasReadPhotoInstructions: true,
        photo: state.photo,
        registerOp: state.registerOp,
      ),
    );
  } else if (state is PhotoSelectedState) {
    emit(
      PhotoSelectedState(
        autovalidateMode: state.autovalidateMode,
        gym: state.gym,
        gyms: state.gyms,
        gymConfirmed: state.gymConfirmed,
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
        location: state.location,
        cameraController: state.cameraController,
        takenEmails: state.takenEmails,
        hasReadPhotoInstructions: true,
        photo: state.photo,
      ),
    );
  } else if (state is CaptureErrorState) {
    emit(
      CaptureErrorState(
        firstNameConfirmed: state.firstNameConfirmed,
        location: state.location,
        gyms: state.gyms,
        currentPage: state.currentPage,
        autovalidateMode: state.autovalidateMode,
        gym: state.gym,
        takenEmails: state.takenEmails,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: true,
        failure: state.failure,
      ),
    );
  } else if (state is CapturingState) {
    emit(
      CapturingState(
        firstNameConfirmed: state.firstNameConfirmed,
        location: state.location,
        gyms: state.gyms,
        currentPage: state.currentPage,
        autovalidateMode: state.autovalidateMode,
        takenEmails: state.takenEmails,
        gym: state.gym,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: true,
        photoCapture: state.photoCapture,
      ),
    );
  } else if (state is CameraErrorState) {
    emit(
      CameraErrorState(
        firstNameConfirmed: state.firstNameConfirmed,
        gyms: state.gyms,
        location: state.location,
        gym: state.gym,
        takenEmails: state.takenEmails,
        currentPage: state.currentPage,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        autovalidateMode: state.autovalidateMode,
        hasReadPhotoInstructions: true,
        failure: state.failure,
      ),
    );
  } else if (state is GymSelectedState) {
    emit(
      GymSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        gyms: state.gyms,
        location: state.location,
        gym: state.gym,
        takenEmails: state.takenEmails,
        currentPage: state.currentPage,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        autovalidateMode: state.autovalidateMode,
        hasReadPhotoInstructions: true,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
