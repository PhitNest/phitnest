import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onSwipe(
  SwipeEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is InitialState) {
    emit(
      InitialState(
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: event.pageIndex,
        loadGymsOp: state.loadGymsOp,
        autovalidateMode: state.autovalidateMode,
      ),
    );
  } else if (state is GymsLoadingErrorState) {
    emit(
      GymsLoadingErrorState(
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: event.pageIndex,
        failure: state.failure,
        autovalidateMode: state.autovalidateMode,
      ),
    );
  } else if (state is GymNotSelectedState) {
    emit(
      GymNotSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: event.pageIndex,
        gyms: state.gyms,
        location: state.location,
        autovalidateMode: state.autovalidateMode,
      ),
    );
  } else if (state is RegisterErrorState) {
    emit(
      RegisterErrorState(
        autovalidateMode: state.autovalidateMode,
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: event.pageIndex,
        gym: state.gym,
        gyms: state.gyms,
        takenEmails: state.takenEmails,
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
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: event.pageIndex,
        gym: state.gym,
        gyms: state.gyms,
        gymConfirmed: state.gymConfirmed,
        location: state.location,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        takenEmails: state.takenEmails,
        photo: state.photo,
        registerOp: state.registerOp,
      ),
    );
  } else if (state is UploadingPhotoState) {
    emit(
      UploadingPhotoState(
        firstNameConfirmed: state.firstNameConfirmed,
        location: state.location,
        gym: state.gym,
        autovalidateMode: state.autovalidateMode,
        currentPage: event.pageIndex,
        gyms: state.gyms,
        takenEmails: state.takenEmails,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        photo: state.photo,
        uploadOp: state.uploadOp,
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
        currentPage: event.pageIndex,
        location: state.location,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        takenEmails: state.takenEmails,
        photo: state.photo,
      ),
    );
  } else if (state is CameraErrorState) {
    emit(
      CameraErrorState(
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: event.pageIndex,
        location: state.location,
        gyms: state.gyms,
        gym: state.gym,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        takenEmails: state.takenEmails,
        autovalidateMode: state.autovalidateMode,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        failure: state.failure,
      ),
    );
  } else if (state is CaptureErrorState) {
    emit(
      CaptureErrorState(
        firstNameConfirmed: state.firstNameConfirmed,
        location: state.location,
        gyms: state.gyms,
        currentPage: event.pageIndex,
        autovalidateMode: state.autovalidateMode,
        gym: state.gym,
        takenEmails: state.takenEmails,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        failure: state.failure,
      ),
    );
  } else if (state is CapturingState) {
    emit(
      CapturingState(
        firstNameConfirmed: state.firstNameConfirmed,
        location: state.location,
        gyms: state.gyms,
        currentPage: event.pageIndex,
        autovalidateMode: state.autovalidateMode,
        gym: state.gym,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        takenEmails: state.takenEmails,
        photoCapture: state.photoCapture,
      ),
    );
  } else if (state is GymSelectedState) {
    emit(
      GymSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: event.pageIndex,
        location: state.location,
        gyms: state.gyms,
        gym: state.gym,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        autovalidateMode: state.autovalidateMode,
        takenEmails: state.takenEmails,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
