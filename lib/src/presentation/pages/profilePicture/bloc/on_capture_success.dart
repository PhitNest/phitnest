import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/profile_picture_event.dart';
import '../state/profile_picture_state.dart';

void onCaptureSuccess(
  CaptureSuccessEvent event,
  Emitter<ProfilePictureState> emit,
  ProfilePictureState state,
) {
  if (state is InitializedState) {
    emit(
      CaptureSuccessState(
        cameraController: state.cameraController,
        file: event.file,
      ),
    );
  } else {
    throw Exception("Invalid state: $state");
  }
}
