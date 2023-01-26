import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/verification_event.dart';
import '../state/verification_state.dart';

void onResendError(
  ResendErrorEvent event,
  Emitter<VerificationState> emit,
  VerificationState state,
) {
  if (state is LoadingState) {
    emit(
      ResendErrorState(
        codeController: state.codeController,
        codeFocusNode: state.codeFocusNode,
        failure: event.failure,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
