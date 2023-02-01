import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/verification_event.dart';
import '../state/verification_state.dart';
import 'on_confirm_error.dart';
import 'on_confirm_success.dart';
import 'on_profile_picture_error.dart';
import 'on_resend.dart';
import 'on_resend_error.dart';
import 'on_reset.dart';
import 'on_submit.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc(bool checkProfilePicture)
      : super(
          InitialState(
            codeController: TextEditingController(),
            codeFocusNode: FocusNode(),
          ),
        ) {
    on<SubmitEvent>((event, emit) => onSubmit(event, emit, state, add));
    on<ConfirmSuccessEvent>(
        (event, emit) => onConfirmSuccess(event, emit, state));
    on<ConfirmErrorEvent>((event, emit) =>
        onConfirmError(event, emit, state, checkProfilePicture));
    on<ResendEvent>((event, emit) => onResend(event, emit, state, add));
    on<ResendErrorEvent>((event, emit) => onResendError(event, emit, state));
    on<ResetEvent>((event, emit) => onReset(event, emit, state));
    on<ProfilePictureErrorEvent>(
        (event, emit) => onProfilePictureError(event, emit, state));
  }

  @override
  Future<void> close() async {
    if (state is InitialState) {
      final initialState = state as InitialState;
      initialState.codeController.dispose();
      initialState.codeFocusNode.dispose();
    }
    if (state is ConfirmingState) {
      final loadingState = state as ConfirmingState;
      await loadingState.operation.cancel();
    }
    return super.close();
  }
}
