import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/use_cases/use_cases.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onRetryLoadGyms(
  RetryLoadGymsEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
  ValueSetter<RegistrationEvent> add,
) {
  if (state is GymsLoadingErrorState) {
    emit(
      GymsLoadingState(
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
        autovalidateMode: state.autovalidateMode,
        loadGymsOp: CancelableOperation.fromFuture(
          loadGyms(),
        )..then(
            (either) => either.fold(
              (success) => add(GymsLoadedEvent(success.value1, success.value2)),
              (failure) => add(GymsLoadingErrorEvent(failure)),
            ),
          ),
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
