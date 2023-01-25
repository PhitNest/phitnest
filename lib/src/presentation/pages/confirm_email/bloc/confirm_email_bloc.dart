import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/confirm_email_event.dart';
import '../state/confirm_email_state.dart';
import 'on_error.dart';
import 'on_submit.dart';
import 'on_success.dart';

class ConfirmEmailBloc extends Bloc<ConfirmEmailEvent, ConfirmEmailState> {
  ConfirmEmailBloc()
      : super(
          InitialState(
            codeController: TextEditingController(),
            codeFocusNode: FocusNode(),
          ),
        ) {
    on<SuccessEvent>((event, emit) => onSuccess(event, emit, state));
    on<ErrorEvent>((event, emit) => onErrorEvent(event, emit, state));
    on<SubmitEvent>((event, emit) => onSubmit(event, emit, state));
  }

  @override
  Future<void> close() async {
    if (state is LoadingState) {
      final loadingState = state as LoadingState;
      await loadingState.confirmEmailRequest.cancel();
    }
    if (state is InitialState) {
      final initialState = state as InitialState;
      initialState.codeController.dispose();
      initialState.codeFocusNode.dispose();
    }
    return super.close();
  }
}
