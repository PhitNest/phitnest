import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/failure.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';

Future<void> onRetryCameraInit(
  RetryCameraInitializationEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) async {
  final cameraErrorState = state as CameraErrorState;
  try {
    await cameraErrorState.cameraController.initialize();
    emit(
      GymSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        location: cameraErrorState.location,
        takenEmails: state.takenEmails,
        gyms: cameraErrorState.gyms,
        currentPage: state.currentPage,
        autovalidateMode: state.autovalidateMode,
        gym: cameraErrorState.gym,
        gymConfirmed: cameraErrorState.gymConfirmed,
        cameraController: cameraErrorState.cameraController,
        hasReadPhotoInstructions: cameraErrorState.hasReadPhotoInstructions,
      ),
    );
  } on CameraException catch (err) {
    emit(
      CameraErrorState(
        firstNameConfirmed: state.firstNameConfirmed,
        location: cameraErrorState.location,
        gyms: cameraErrorState.gyms,
        currentPage: state.currentPage,
        takenEmails: state.takenEmails,
        autovalidateMode: state.autovalidateMode,
        gym: cameraErrorState.gym,
        gymConfirmed: cameraErrorState.gymConfirmed,
        cameraController: cameraErrorState.cameraController,
        hasReadPhotoInstructions: cameraErrorState.hasReadPhotoInstructions,
        failure:
            Failure(err.code, "Please enable camera access\nand try again."),
      ),
    );
  }
}
