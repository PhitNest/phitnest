import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants/constants.dart';
import '../event/verification_event.dart';
import '../state/verification_state.dart';

void onSubmit(
  SubmitEvent event,
  Emitter<VerificationState> emit,
  VerificationState state,
  ValueChanged<VerificationEvent> add,
) {
  if (state is InitialState) {
    if (state.codeController.text.length != 6) {
      emit(
        ConfirmErrorState(
          codeController: state.codeController,
          codeFocusNode: state.codeFocusNode,
          failure: Failures.invalidCode.instance,
        ),
      );
    } else {
      emit(
        LoadingState(
          codeController: state.codeController,
          codeFocusNode: state.codeFocusNode,
          operation: CancelableOperation.fromFuture(
            event.confirmation(
              state.codeController.text,
            )..then(
                (failure) {
                  if (failure != null) {
                    add(ConfirmErrorEvent(failure));
                  } else {
                    add(const ConfirmSuccessEvent());
                  }
                },
              ),
          ),
        ),
      );
    }
  } else {
    throw Exception('Invalid state: $state');
  }
}
