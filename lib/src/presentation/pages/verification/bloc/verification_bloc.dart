import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/verification_event.dart';
import '../state/verification_state.dart';
import 'on_clear_error.dart';
import 'on_confirm_error.dart';
import 'on_confirm_success.dart';
import 'on_resend.dart';
import 'on_resend_error.dart';
import 'on_reset.dart';
import 'on_submit.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc()
      : super(
          InitialState(
            codeController: TextEditingController(),
            codeFocusNode: FocusNode(),
          ),
        ) {
    on<SubmitEvent>((event, emit) => onSubmit(event, emit, state, add));
    on<ConfirmSuccessEvent>(
        (event, emit) => onConfirmSuccess(event, emit, state));
    on<ConfirmErrorEvent>((event, emit) => onConfirmError(event, emit, state));
    on<ResendEvent>((event, emit) => onResend(event, emit, state, add));
    on<ResendErrorEvent>((event, emit) => onResendError(event, emit, state));
    on<ResetEvent>((event, emit) => onReset(event, emit, state));
    on<ClearErrorEvent>((event, emit) => onClearError(event, emit, state));
  }

  @override
  Future<void> close() async {
    if (state is InitialState) {
      final initialState = state as InitialState;
      initialState.codeController.dispose();
      initialState.codeFocusNode.dispose();
    }
    if (state is LoadingState) {
      final loadingState = state as LoadingState;
      await loadingState.operation.cancel();
    }
    return super.close();
  }
}
