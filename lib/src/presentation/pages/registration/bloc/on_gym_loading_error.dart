import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onGymsLoadingError(
  GymsLoadingErrorEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
) {
  if (state is GymsLoadingState) {
    emit(
      GymsLoadingErrorState(
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
        currentPage: state.currentPage,
        failure: event.failure,
        autovalidateMode: state.autovalidateMode,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
