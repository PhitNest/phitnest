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
  if (state is RegisterRequestErrorState) {
    emit(
      state.copyWith(
        gym: event.gym,
        gymConfirmed: false,
      ),
    );
  } else if (state is RegisterRequestLoadingState) {
    emit(
      state.copyWith(
        gym: event.gym,
        gymConfirmed: false,
      ),
    );
  } else if (state is PhotoSelectedState) {
    emit(
      state.copyWith(
        gym: event.gym,
        gymConfirmed: false,
      ),
    );
  } else if (state is CaptureErrorState) {
    emit(
      state.copyWith(
        gym: event.gym,
        gymConfirmed: false,
      ),
    );
  } else if (state is CapturingState) {
    emit(
      state.copyWith(
        gym: event.gym,
        gymConfirmed: false,
      ),
    );
  } else if (state is CameraErrorState) {
    emit(
      state.copyWith(
        gym: event.gym,
        gymConfirmed: false,
      ),
    );
  } else if (state is GymSelectedState) {
    emit(
      state.copyWith(
        gym: event.gym,
        gymConfirmed: false,
      ),
    );
  } else if (state is GymsLoadedState) {
    emit(
      GymSelectedState(
        firstNameController: state.firstNameController,
        lastNameController: state.lastNameController,
        emailController: state.emailController,
        passwordController: state.passwordController,
        confirmPasswordController: state.confirmPasswordController,
        firstNameFocusNode: state.firstNameFocusNode,
        lastNameFocusNode: state.lastNameFocusNode,
        emailFocusNode: state.emailFocusNode,
        passwordFocusNode: state.passwordFocusNode,
        confirmPasswordFocusNode: state.confirmPasswordFocusNode,
        pageController: state.pageController,
        pageOneFormKey: state.pageOneFormKey,
        pageTwoFormKey: state.pageTwoFormKey,
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
