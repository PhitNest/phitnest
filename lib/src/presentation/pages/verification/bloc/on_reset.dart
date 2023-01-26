import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/verification_event.dart';
import '../state/verification_state.dart';

void onReset(
  ResetEvent event,
  Emitter<VerificationState> emit,
  VerificationState state,
) {
  emit(
    InitialState(
      codeController: TextEditingController(),
      codeFocusNode: FocusNode(),
    ),
  );
}
