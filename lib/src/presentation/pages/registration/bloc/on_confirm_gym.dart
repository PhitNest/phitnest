import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/failure.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';

Future<void> onGymConfirmed(
  ConfirmGymEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) async {
  if (state is InitialState) {
    if (state is RegisterRequestErrorState) {
      emit(
        state.copyWith(
          gymConfirmed: true,
        ),
      );
    } else if (state is RegisterRequestLoadingState) {
      emit(
        state.copyWith(
          gymConfirmed: true,
        ),
      );
    } else if (state is PhotoSelectedState) {
      emit(
        state.copyWith(
          gymConfirmed: true,
        ),
      );
    } else if (state is CaptureErrorState) {
      emit(
        state.copyWith(
          gymConfirmed: true,
        ),
      );
    } else if (state is CapturingState) {
      emit(
        state.copyWith(
          gymConfirmed: true,
        ),
      );
    } else if (state is GymSelectedState) {
      try {
        if (!state.cameraController.value.isInitialized) {
          await state.cameraController.initialize();
        }
        emit(
          state.copyWith(
            gymConfirmed: true,
          ),
        );
      } on CameraException catch (err) {
        emit(
          CameraErrorState(
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
            takenEmails: state.takenEmails,
            autovalidateMode: state.autovalidateMode,
            gym: state.gym,
            gymConfirmed: true,
            cameraController: state.cameraController,
            hasReadPhotoInstructions: state.hasReadPhotoInstructions,
            failure: Failure(
                err.code,
                err.description ??
                    "Please enable camera access\nand try again."),
          ),
        );
      }
    } else {
      throw Exception('Invalid state: $state');
    }
    state.pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
