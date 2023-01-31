import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/verification_event.dart';
import '../state/verification_state.dart';

void onResend(
  ResendEvent event,
  Emitter<VerificationState> emit,
  VerificationState state,
  ValueChanged<VerificationEvent> add,
) {
  if (state is InitialState) {
    emit(
      ResendingState(
        codeController: state.codeController,
        codeFocusNode: state.codeFocusNode,
        operation: CancelableOperation.fromFuture(
          event.resend()
            ..then(
              (failure) {
                if (failure != null) {
                  add(ResendErrorEvent(failure));
                } else {
                  add(const ResetEvent());
                }
              },
            ),
        ),
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
