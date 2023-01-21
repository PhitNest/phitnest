import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/validators.dart';
import '../../../../domain/repositories/repositories.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onRegister(
  RegisterEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
  ValueChanged<RegistrationEvent> add,
  PageController pageController,
  String firstName,
  String lastName,
  String email,
  String password,
  String confirmPassword,
) {
  final photoSelectedState = state as PhotoSelectedState;
  if (validateName(firstName) != null || validateName(lastName) != null) {
    pageController.jumpToPage(0);
    Future.delayed(Duration(milliseconds: 50), () => add(SubmitPageOneEvent()));
  } else if (validateEmail(email) != null ||
      state.takenEmails.contains(email) ||
      validatePassword(password) != null ||
      password != confirmPassword) {
    pageController.jumpToPage(1);
    Future.delayed(Duration(milliseconds: 50), () => add(SubmitPageTwoEvent()));
  } else {
    emit(
      RegisteringState(
        autovalidateMode: state.autovalidateMode,
        photo: photoSelectedState.photo,
        gym: photoSelectedState.gym,
        firstNameConfirmed: photoSelectedState.firstNameConfirmed,
        gymConfirmed: photoSelectedState.gymConfirmed,
        currentPage: photoSelectedState.currentPage,
        takenEmails: state.takenEmails,
        gyms: photoSelectedState.gyms,
        location: photoSelectedState.location,
        cameraController: photoSelectedState.cameraController,
        hasReadPhotoInstructions: photoSelectedState.hasReadPhotoInstructions,
        registerOp: CancelableOperation.fromFuture(
          authRepo.register(
            email,
            password,
            firstName,
            lastName,
            state.gym.id,
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
