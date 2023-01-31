import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

Future<void> onGymSelected(
  GymSelectedEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) async {
  if (state is RegisterRequestErrorState) {
    emit(state.copyWith(gym: event.gym));
  } else if (state is RegisterRequestLoadingState) {
    emit(state.copyWith(gym: event.gym));
  } else if (state is GymSelectedState) {
    emit(state.copyWith(gym: event.gym));
  } else if (state is GymsLoadedState) {
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
        firstNameConfirmed: state.firstNameConfirmed,
        gyms: state.gyms,
        takenEmails: {},
        location: state.location,
        gym: event.gym,
        currentPage: state.currentPage,
        autovalidateMode: state.autovalidateMode,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
