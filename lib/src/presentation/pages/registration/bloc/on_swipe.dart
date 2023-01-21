import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onSwipe(
  SwipeEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is InitialState) {
    if (state is RegisterRequestErrorState) {
      emit(
        state.copyWith(
          currentPage: event.pageIndex,
        ),
      );
    } else if (state is RegisterRequestLoadingState) {
      emit(
        state.copyWith(
          currentPage: event.pageIndex,
        ),
      );
    } else if (state is PhotoSelectedState) {
      emit(
        state.copyWith(
          currentPage: event.pageIndex,
        ),
      );
    } else if (state is CameraErrorState) {
      emit(
        state.copyWith(
          currentPage: event.pageIndex,
        ),
      );
    } else if (state is CaptureErrorState) {
      emit(
        state.copyWith(
          currentPage: event.pageIndex,
        ),
      );
    } else if (state is CapturingState) {
      emit(
        state.copyWith(
          currentPage: event.pageIndex,
        ),
      );
    } else if (state is GymSelectedState) {
      emit(
        state.copyWith(
          currentPage: event.pageIndex,
        ),
      );
    } else if (state is GymsLoadedState) {
      emit(
        state.copyWith(
          currentPage: event.pageIndex,
        ),
      );
    } else if (state is GymsLoadingErrorState) {
      emit(
        state.copyWith(
          currentPage: event.pageIndex,
        ),
      );
    } else if (state is GymsLoadingState) {
      emit(
        state.copyWith(
          currentPage: event.pageIndex,
        ),
      );
    } else {
      throw Exception('Invalid state: $state');
    }
    state.firstNameFocusNode.unfocus();
    state.lastNameFocusNode.unfocus();
    state.emailFocusNode.unfocus();
    state.passwordFocusNode.unfocus();
    state.confirmPasswordFocusNode.unfocus();
  } else {
    throw Exception('Invalid state: $state');
  }
}
