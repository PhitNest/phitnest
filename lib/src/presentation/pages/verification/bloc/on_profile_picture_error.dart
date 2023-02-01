import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/verification_event.dart';
import '../state/verification_state.dart';

void onProfilePictureError(
  ProfilePictureErrorEvent event,
  Emitter<VerificationState> emit,
  VerificationState state,
) {
  if (state is ConfirmingState) {
    emit(
      ProfilePictureErrorState(
        codeController: state.codeController,
        codeFocusNode: state.codeFocusNode,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
