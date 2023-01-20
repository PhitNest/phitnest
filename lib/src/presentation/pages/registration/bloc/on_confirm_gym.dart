import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/failure.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';

Future<void> onGymConfirmed(
  ConfirmGymEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) async {
  if (state is RegisterErrorState) {
    emit(
      RegisterErrorState(
        autovalidateMode: state.autovalidateMode,
        takenEmails: state.takenEmails,
        gym: state.gym,
        gyms: state.gyms,
        gymConfirmed: true,
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
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
        gym: state.gym,
        gyms: state.gyms,
        gymConfirmed: state.gymConfirmed,
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
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
        firstNameConfirmed: state.firstNameConfirmed,
        location: state.location,
        gym: state.gym,
        autovalidateMode: state.autovalidateMode,
        currentPage: state.currentPage,
        gyms: state.gyms,
        takenEmails: state.takenEmails,
        gymConfirmed: true,
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
        gymConfirmed: true,
        takenEmails: state.takenEmails,
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
        location: state.location,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
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
        gymConfirmed: true,
        cameraController: state.cameraController,
        takenEmails: state.takenEmails,
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
        autovalidateMode: state.autovalidateMode,
        gym: state.gym,
        takenEmails: state.takenEmails,
        gymConfirmed: true,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        photoCapture: state.photoCapture,
      ),
    );
  } else if (state is GymSelectedState) {
    try {
      if (!state.cameraController.value.isInitialized) {
        await state.cameraController.initialize();
      }
      emit(
        GymSelectedState(
          firstNameConfirmed: state.firstNameConfirmed,
          gyms: state.gyms,
          currentPage: state.currentPage,
          location: state.location,
          takenEmails: state.takenEmails,
          gym: state.gym,
          gymConfirmed: true,
          cameraController: state.cameraController,
          autovalidateMode: state.autovalidateMode,
          hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        ),
      );
    } on CameraException catch (err) {
      emit(
        CameraErrorState(
          firstNameConfirmed: state.firstNameConfirmed,
          location: state.location,
          gyms: state.gyms,
          currentPage: state.currentPage,
          takenEmails: state.takenEmails,
          autovalidateMode: state.autovalidateMode,
          gym: state.gym,
          gymConfirmed: state.gymConfirmed,
          cameraController: state.cameraController,
          hasReadPhotoInstructions: state.hasReadPhotoInstructions,
          failure:
              Failure(err.code, "Please enable camera access\nand try again."),
        ),
      );
    }
  } else {
    throw Exception('Invalid state: $state');
  }
}
