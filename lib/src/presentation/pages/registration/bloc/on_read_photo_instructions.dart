import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onReadPhotoInstructions(
  ReadPhotoInstructionsEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) async {
  if (state is InitialState) {
    if (state is RegisterRequestErrorState) {
      emit(
        state.copyWith(
          hasReadPhotoInstructions: true,
        ),
      );
    } else if (state is RegisterRequestLoadingState) {
      emit(
        state.copyWith(
          hasReadPhotoInstructions: true,
        ),
      );
    } else if (state is PhotoSelectedState) {
      emit(
        state.copyWith(
          hasReadPhotoInstructions: true,
        ),
      );
    } else if (state is CaptureErrorState) {
      emit(
        state.copyWith(
          hasReadPhotoInstructions: true,
        ),
      );
    } else if (state is CapturingState) {
      emit(
        state.copyWith(
          hasReadPhotoInstructions: true,
        ),
      );
    } else if (state is CameraErrorState) {
      emit(
        state.copyWith(
          hasReadPhotoInstructions: true,
        ),
      );
    } else if (state is GymSelectedState) {
      emit(
        state.copyWith(
          hasReadPhotoInstructions: true,
        ),
      );
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
