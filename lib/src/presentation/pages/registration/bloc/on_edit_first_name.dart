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
  if (state is InitialState) {
    emit(
      InitialState(
        firstNameConfirmed: validation == null,
        currentPage: state.currentPage,
        loadGymsOp: state.loadGymsOp,
        autovalidateMode: state.autovalidateMode,
      ),
    );
  } else if (state is GymNotSelectedState) {
    emit(
      GymNotSelectedState(
        firstNameConfirmed: validation == null,
        gyms: state.gyms,
        currentPage: state.currentPage,
        location: state.location,
        autovalidateMode: state.autovalidateMode,
      ),
    );
  } else if (state is GymsLoadingErrorState) {
    emit(
      GymsLoadingErrorState(
        firstNameConfirmed: validation == null,
        currentPage: state.currentPage,
        failure: state.failure,
        autovalidateMode: state.autovalidateMode,
      ),
    );
  } else if (state is RegisterErrorState) {
    emit(
      RegisterErrorState(
        autovalidateMode: state.autovalidateMode,
        firstNameConfirmed: validation == null,
        currentPage: state.currentPage,
        takenEmails: state.takenEmails,
        gym: state.gym,
        gyms: state.gyms,
        gymConfirmed: state.gymConfirmed,
        location: state.location,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        photo: state.photo,
        failure: state.failure,
      ),
    );
  } else if (state is RegisteringState) {
    emit(
      RegisteringState(
        autovalidateMode: state.autovalidateMode,
        firstNameConfirmed: validation == null,
        currentPage: state.currentPage,
        gym: state.gym,
        gyms: state.gyms,
        gymConfirmed: state.gymConfirmed,
        takenEmails: state.takenEmails,
        location: state.location,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        photo: state.photo,
        registerOp: state.registerOp,
      ),
    );
  } else if (state is UploadingPhotoState) {
    emit(
      UploadingPhotoState(
          firstNameConfirmed: validation == null,
          location: state.location,
          gym: state.gym,
          autovalidateMode: state.autovalidateMode,
          currentPage: state.currentPage,
          gyms: state.gyms,
          takenEmails: state.takenEmails,
          gymConfirmed: state.gymConfirmed,
          cameraController: state.cameraController,
          hasReadPhotoInstructions: state.hasReadPhotoInstructions,
          photo: state.photo,
          uploadOp: state.uploadOp),
    );
  } else if (state is PhotoSelectedState) {
    emit(
      PhotoSelectedState(
        autovalidateMode: state.autovalidateMode,
        gym: state.gym,
        gyms: state.gyms,
        gymConfirmed: state.gymConfirmed,
        firstNameConfirmed: validation == null,
        currentPage: state.currentPage,
        takenEmails: state.takenEmails,
        location: state.location,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        photo: state.photo,
      ),
    );
  } else if (state is CaptureErrorState) {
    emit(
      CaptureErrorState(
        firstNameConfirmed: validation == null,
        location: state.location,
        gyms: state.gyms,
        takenEmails: state.takenEmails,
        currentPage: state.currentPage,
        autovalidateMode: state.autovalidateMode,
        gym: state.gym,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        failure: state.failure,
      ),
    );
  } else if (state is CapturingState) {
    emit(
      CapturingState(
        firstNameConfirmed: validation == null,
        location: state.location,
        currentPage: state.currentPage,
        gyms: state.gyms,
        gym: state.gym,
        takenEmails: state.takenEmails,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        autovalidateMode: state.autovalidateMode,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        photoCapture: state.photoCapture,
      ),
    );
  } else if (state is CameraErrorState) {
    emit(
      CameraErrorState(
        firstNameConfirmed: validation == null,
        location: state.location,
        currentPage: state.currentPage,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        takenEmails: state.takenEmails,
        gyms: state.gyms,
        gym: state.gym,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        autovalidateMode: state.autovalidateMode,
        failure: state.failure,
      ),
    );
  } else if (state is GymSelectedState) {
    emit(
      GymSelectedState(
        firstNameConfirmed: validation == null,
        location: state.location,
        currentPage: state.currentPage,
        takenEmails: state.takenEmails,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        gyms: state.gyms,
        gym: state.gym,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        autovalidateMode: state.autovalidateMode,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
