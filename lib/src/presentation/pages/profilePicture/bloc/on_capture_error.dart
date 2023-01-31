import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/profile_picture_event.dart';
import '../state/profile_picture_state.dart';

void onCaptureError(
  CaptureErrorEvent event,
  Emitter<ProfilePictureState> emit,
  ProfilePictureState state,
) {
  if (state is CaptureLoadingState) {
    emit(
      CaptureErrorState(
        cameraController: state.cameraController,
        failure: event.failure,
      ),
    );
  } else {
    throw Exception("Invalid state: $state");
  }
}
