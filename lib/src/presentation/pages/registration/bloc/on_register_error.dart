import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onRegisterError(
  RegisterErrorEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
  ValueChanged<RegistrationEvent> add,
) {
  if (state is RegisterRequestLoadingState) {
    if (event.failure.code == "UsernameExistsException") {
      state.pageController.jumpToPage(1);
      emit(
        PhotoSelectedState(
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
          autovalidateMode: state.autovalidateMode,
          gym: state.gym,
          gyms: state.gyms,
          gymConfirmed: state.gymConfirmed,
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: state.currentPage,
          takenEmails: {
            ...state.takenEmails,
            state.emailController.text.trim()
          },
          location: state.location,
          cameraController: state.cameraController,
          hasReadPhotoInstructions: state.hasReadPhotoInstructions,
          photo: state.photo,
        ),
      );
      // Delay the event to allow the page to render... IS THERE A BETTER WAY TO DO THIS? :(
      Future.delayed(
          Duration(milliseconds: 50), () => add(SubmitPageTwoEvent()));
    } else {
      state.pageController.jumpToPage(5);
      emit(
        RegisterRequestErrorState(
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
          autovalidateMode: state.autovalidateMode,
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: state.currentPage,
          gym: state.gym,
          gyms: state.gyms,
          gymConfirmed: state.gymConfirmed,
          location: state.location,
          takenEmails: state.takenEmails,
          cameraController: state.cameraController,
          hasReadPhotoInstructions: state.hasReadPhotoInstructions,
          photo: state.photo,
          failure: event.failure,
        ),
      );
    }
  } else {
    throw Exception("Invalid state: $state");
  }
}
