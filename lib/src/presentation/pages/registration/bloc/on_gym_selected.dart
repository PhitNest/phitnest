import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

Future<CameraDescription> _getFrontCamera() async {
  final cameras = await availableCameras();
  return cameras.firstWhere(
    (element) => element.lensDirection == CameraLensDirection.front,
    orElse: () => cameras.first,
  );
}

Future<void> onGymSelected(
  GymSelectedEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) async {
  if (state is RegisterErrorState) {
    emit(
      RegisterErrorState(
        autovalidateMode: state.autovalidateMode,
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
        gym: event.gym,
        gyms: state.gyms,
        gymConfirmed: false,
        location: state.location,
        takenEmails: state.takenEmails,
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
        currentPage: state.currentPage,
        gym: event.gym,
        gymConfirmed: false,
        gyms: state.gyms,
        location: state.location,
        cameraController: state.cameraController,
        takenEmails: state.takenEmails,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        photo: state.photo,
        registerOp: state.registerOp,
      ),
    );
  } else if (state is PhotoSelectedState) {
    emit(
      PhotoSelectedState(
        autovalidateMode: state.autovalidateMode,
        gym: event.gym,
        gymConfirmed: false,
        gyms: state.gyms,
        firstNameConfirmed: state.firstNameConfirmed,
        currentPage: state.currentPage,
        location: state.location,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        photo: state.photo,
        takenEmails: state.takenEmails,
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
        gym: event.gym,
        takenEmails: state.takenEmails,
        gymConfirmed: false,
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
        autovalidateMode: state.autovalidateMode,
        gym: event.gym,
        takenEmails: state.takenEmails,
        gymConfirmed: false,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        photoCapture: state.photoCapture,
      ),
    );
  } else if (state is CameraErrorState) {
    emit(
      CameraErrorState(
        firstNameConfirmed: state.firstNameConfirmed,
        gyms: state.gyms,
        location: state.location,
        gym: event.gym,
        currentPage: state.currentPage,
        gymConfirmed: false,
        cameraController: state.cameraController,
        autovalidateMode: state.autovalidateMode,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
        failure: state.failure,
        takenEmails: state.takenEmails,
      ),
    );
  } else if (state is GymSelectedState) {
    emit(
      GymSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        gyms: state.gyms,
        takenEmails: state.takenEmails,
        location: state.location,
        gym: event.gym,
        currentPage: state.currentPage,
        gymConfirmed: false,
        cameraController: state.cameraController,
        autovalidateMode: state.autovalidateMode,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
      ),
    );
  } else if (state is GymNotSelectedState) {
    emit(
      GymSelectedState(
        firstNameConfirmed: state.firstNameConfirmed,
        gyms: state.gyms,
        takenEmails: {},
        location: state.location,
        gym: event.gym,
        currentPage: state.currentPage,
        gymConfirmed: false,
        autovalidateMode: state.autovalidateMode,
        hasReadPhotoInstructions: false,
        cameraController: CameraController(
          await _getFrontCamera(),
          ResolutionPreset.max,
          enableAudio: false,
        ),
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
