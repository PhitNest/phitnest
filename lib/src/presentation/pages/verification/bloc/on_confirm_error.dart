import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants/constants.dart';
import '../event/verification_event.dart';
import '../state/verification_state.dart';

void onConfirmError(
  ConfirmErrorEvent event,
  Emitter<VerificationState> emit,
  VerificationState state,
  bool checkProfilePicture,
) {
  if (state is ConfirmingState) {
    if (checkProfilePicture &&
        event.failure == Failures.profilePictureNotFound.instance) {
      emit(
        ProfilePictureErrorState(
          codeController: state.codeController,
          codeFocusNode: state.codeFocusNode,
        ),
      );
    } else {
      emit(
        ConfirmErrorState(
          codeController: state.codeController,
          codeFocusNode: state.codeFocusNode,
          failure: event.failure,
        ),
      );
    }
  } else {
    throw Exception('Invalid state: $state');
  }
}
