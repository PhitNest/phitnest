import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/verification_event.dart';
import '../state/verification_state.dart';

void onClearError(
  ClearErrorEvent event,
  Emitter<VerificationState> emit,
  VerificationState state,
) {
  if (state is ConfirmErrorState) {
    emit(
      InitialState(
        codeController: state.codeController,
        codeFocusNode: state.codeFocusNode,
      ),
    );
  } else if (state is ResendErrorState) {
    emit(
      InitialState(
        codeController: state.codeController,
        codeFocusNode: state.codeFocusNode,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
