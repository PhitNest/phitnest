import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/registration_state.dart';

void onValidationFailed(
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is InitialState) {
    emit(
      InitialState(
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
        autovalidateMode: AutovalidateMode.always,
        loadGymsOp: state.loadGymsOp,
      ),
    );
  } else if (state is GymsLoadingErrorState) {
    emit(
      GymsLoadingErrorState(
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
        autovalidateMode: AutovalidateMode.always,
        failure: state.failure,
      ),
    );
  } else if (state is RegisterErrorState) {
    emit(
      RegisterErrorState(
        autovalidateMode: AutovalidateMode.always,
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
        gym: state.gym,
        takenEmails: state.takenEmails,
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
        autovalidateMode: AutovalidateMode.always,
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
        gym: state.gym,
        gyms: state.gyms,
        takenEmails: state.takenEmails,
        gymConfirmed: state.gymConfirmed,
        location: state.location,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        photo: state.photo,
        registerOp: state.registerOp,
      ),
    );
  } else if (state is PhotoSelectedState) {
    emit(
      PhotoSelectedState(
        autovalidateMode: AutovalidateMode.always,
        gym: state.gym,
        gyms: state.gyms,
        gymConfirmed: state.gymConfirmed,
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
        location: state.location,
        cameraController: state.cameraController,
        takenEmails: state.takenEmails,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        photo: state.photo,
      ),
    );
  } else if (state is CameraErrorState) {
    emit(
      CameraErrorState(
        firstNameConfirmed: state.firstNameConfirmed,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        currentPage: state.currentPage,
        takenEmails: state.takenEmails,
        autovalidateMode: AutovalidateMode.always,
        location: state.location,
        gyms: state.gyms,
        gym: state.gym,
        gymConfirmed: state.gymConfirmed,
        failure: state.failure,
      ),
    );
  } else if (state is CaptureErrorState) {
    emit(
      CaptureErrorState(
        firstNameConfirmed: state.firstNameConfirmed,
        location: state.location,
        gyms: state.gyms,
        currentPage: state.currentPage,
        autovalidateMode: AutovalidateMode.always,
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
        currentPage: state.currentPage,
        autovalidateMode: AutovalidateMode.always,
        gym: state.gym,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        takenEmails: state.takenEmails,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        photoCapture: state.photoCapture,
      ),
    );
  } else if (state is GymSelectedState) {
    emit(
      GymSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
        autovalidateMode: AutovalidateMode.always,
        location: state.location,
        gyms: state.gyms,
        gym: state.gym,
        gymConfirmed: state.gymConfirmed,
        takenEmails: state.takenEmails,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
      ),
    );
  } else if (state is GymNotSelectedState) {
    emit(
      GymNotSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
        autovalidateMode: AutovalidateMode.always,
        gyms: state.gyms,
        location: state.location,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
