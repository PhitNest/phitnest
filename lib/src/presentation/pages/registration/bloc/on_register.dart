import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/validators.dart';
import '../../../../domain/repositories/repository.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onRegister(
  RegisterEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
  ValueChanged<RegistrationEvent> add,
) {
  if (state is GymSelectedState) {
    // Validate (we can't use the form key because we aren't currently on these pages)
    if (validateName(state.firstNameController.text) != null ||
        validateName(state.lastNameController.text) != null) {
      state.pageController.jumpToPage(0);
      Future.delayed(
          Duration(milliseconds: 50), () => add(const SubmitPageOneEvent()));
    } else if (validateEmail(state.emailController.text) != null ||
        state.takenEmails.contains(state.emailController.text) ||
        validatePassword(state.passwordController.text) != null ||
        state.passwordController.text != state.confirmPasswordController.text) {
      state.pageController.jumpToPage(1);
      // Delay for page rendering
      Future.delayed(
          Duration(milliseconds: 100), () => add(const SubmitPageTwoEvent()));
    } else {
      emit(
        RegisterRequestLoadingState(
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
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: state.currentPage,
          takenEmails: state.takenEmails,
          gyms: state.gyms,
          location: state.location,
          registerOp: CancelableOperation.fromFuture(
            Repositories.auth.register(
              email: state.emailController.text.trim(),
              password: state.passwordController.text.trim(),
              firstName: state.firstNameController.text.trim(),
              lastName: state.lastNameController.text.trim(),
              gymId: state.gym.id,
            ),
          )..then(
              (either) => either.fold(
                (success) => add(RegisterSuccessEvent(success)),
                (failure) => add(RegisterErrorEvent(failure)),
              ),
            ),
        ),
      );
    }
  }
}
