import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/verification.dart';
import '../state/verification.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc()
      : super(
          InitialState(
            codeController: TextEditingController(),
            codeFocusNode: FocusNode(),
          ),
        ) {}

  @override
  Future<void> close() {
    if (state is InitialState) {
      final initialState = state as InitialState;
      initialState.codeController.dispose();
      initialState.codeFocusNode.dispose();
    }
    return super.close();
  }
}
