import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants/constants.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onRegisterError(
  RegisterErrorEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
  ValueChanged<RegistrationEvent> add,
) {
  if (state is RegisterRequestLoadingState) {
    if (event.failure == Failures.usernameExists.instance) {
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
          autovalidateMode: AutovalidateMode.always,
          gym: state.gym,
          gyms: state.gyms,
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: state.currentPage,
          takenEmails: {
            ...state.takenEmails,
            state.emailController.text.trim()
          },
          location: state.location,
        ),
      );
      Future.delayed(const Duration(milliseconds: 200),
          () => state.pageController.jumpToPage(1)).then(
        (_) => Future.delayed(
          Duration(milliseconds: 100),
          () => add(const SubmitPageTwoEvent()),
        ),
      );
    } else {
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
          location: state.location,
          takenEmails: state.takenEmails,
          failure: event.failure,
        ),
      );
      Future.delayed(const Duration(milliseconds: 200),
          () => state.pageController.jumpToPage(3));
    }
  } else {
    throw Exception("Invalid state: $state");
  }
}
