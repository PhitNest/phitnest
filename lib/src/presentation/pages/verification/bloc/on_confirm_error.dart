import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/verification_event.dart';
import '../state/verification_state.dart';

void onConfirmError(
  ConfirmErrorEvent event,
  Emitter<VerificationState> emit,
  VerificationState state,
) {
  if (state is ConfirmingState) {
    emit(
      ConfirmErrorState(
        codeController: state.codeController,
        codeFocusNode: state.codeFocusNode,
        failure: event.failure,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
