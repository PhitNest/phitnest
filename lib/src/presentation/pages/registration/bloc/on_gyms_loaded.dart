import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onGymsLoaded(
  GymsLoadedEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is GymsLoadingState) {
    emit(
      GymsLoadedState(
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
        gyms: event.gyms,
        location: event.location,
        currentPage: state.currentPage,
        autovalidateMode: state.autovalidateMode,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
