import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onSetProfilePicture(
  SetProfilePictureEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is GymSelectedState) {
    emit(
      PhotoSelectedState(
        photo: event.image,
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
        location: state.location,
        gyms: state.gyms,
        currentPage: state.currentPage,
        autovalidateMode: state.autovalidateMode,
        gym: state.gym,
        takenEmails: state.takenEmails,
        gymConfirmed: state.gymConfirmed,
        cameraController: state.cameraController,
        hasReadPhotoInstructions: state.hasReadPhotoInstructions,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
