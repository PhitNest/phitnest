import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onRegisterError(
  RegisterErrorEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
  ValueChanged<RegistrationEvent> add,
  PageController pageController,
  String email,
) {
  if (state is RegisteringState) {
    if (event.failure.code == "UsernameExistsException") {
      pageController.jumpToPage(1);
      emit(
        PhotoSelectedState(
          autovalidateMode: state.autovalidateMode,
          gym: state.gym,
          gyms: state.gyms,
          gymConfirmed: state.gymConfirmed,
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: state.currentPage,
          takenEmails: {...state.takenEmails, email},
          location: state.location,
          cameraController: state.cameraController,
          hasReadPhotoInstructions: state.hasReadPhotoInstructions,
          photo: state.photo,
        ),
      );
      Future.delayed(
          Duration(milliseconds: 50), () => add(SubmitPageTwoEvent()));
    } else {
      pageController.jumpToPage(5);
      emit(
        RegisterErrorState(
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
