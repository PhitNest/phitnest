import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onCapturePhoto(
  CapturePhotoEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
  ValueChanged<RegistrationEvent> add,
) {
  final gymSelectedState = state as GymSelectedState;
  emit(
    CapturingState(
      firstNameConfirmed: state.firstNameConfirmed,
      location: gymSelectedState.location,
      gyms: gymSelectedState.gyms,
      currentPage: state.currentPage,
      takenEmails: state.takenEmails,
      autovalidateMode: state.autovalidateMode,
      gym: gymSelectedState.gym,
      gymConfirmed: gymSelectedState.gymConfirmed,
      cameraController: gymSelectedState.cameraController,
      hasReadPhotoInstructions: gymSelectedState.hasReadPhotoInstructions,
      photoCapture: CancelableOperation.fromFuture(
        gymSelectedState.cameraController.takePicture(),
      )..value.catchError(
          (err) {
            if (err is CameraException) {
              add(CaptureErrorEvent(err));
            } else {
              throw err;
            }
          },
        ).then(
          (photo) => add(
            SetProfilePictureEvent(photo),
          ),
        ),
    ),
  );
}
