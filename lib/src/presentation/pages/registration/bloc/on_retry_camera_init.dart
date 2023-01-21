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
  if (state is CameraErrorState) {
    try {
      await state.cameraController.initialize();
      emit(
        GymSelectedState(
          firstNameConfirmed: state.firstNameConfirmed,
          location: state.location,
          takenEmails: state.takenEmails,
          gyms: state.gyms,
          currentPage: state.currentPage,
          autovalidateMode: state.autovalidateMode,
          gym: state.gym,
          gymConfirmed: state.gymConfirmed,
          cameraController: state.cameraController,
          hasReadPhotoInstructions: state.hasReadPhotoInstructions,
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
        ),
      );
    } on CameraException catch (err) {
      emit(
        state.copyWith(
          failure: Failure(err.code,
              err.description ?? "Please enable camera access\nand try again."),
        ),
      );
    }
  } else {
    throw Exception("Invalid state: $state");
  }
}
