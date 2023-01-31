import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onSubmitPageOne(
  SubmitPageOneEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is InitialState) {
    if (state.pageOneFormKey.currentState!.validate()) {
      state.pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      if (state is RegisterRequestErrorState) {
        emit(
          state.copyWith(
            autovalidateMode: AutovalidateMode.always,
          ),
        );
      } else if (state is RegisterRequestLoadingState) {
        emit(
          state.copyWith(
            autovalidateMode: AutovalidateMode.always,
          ),
        );
      } else if (state is GymSelectedState) {
        emit(
          state.copyWith(
            autovalidateMode: AutovalidateMode.always,
          ),
        );
      } else if (state is GymsLoadedState) {
        emit(
          state.copyWith(
            autovalidateMode: AutovalidateMode.always,
          ),
        );
      } else if (state is GymsLoadingState) {
        emit(
          state.copyWith(
            autovalidateMode: AutovalidateMode.always,
          ),
        );
      } else if (state is GymsLoadingErrorState) {
        emit(
          state.copyWith(
            autovalidateMode: AutovalidateMode.always,
          ),
        );
      } else {
        throw Exception('Invalid state: $state');
      }
    }
  } else {
    throw Exception('Invalid state: $state');
  }
}
