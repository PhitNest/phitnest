import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/profile_picture_event.dart';
import '../state/profile_picture_state.dart';

void onCameraLoaded(
  CameraLoadedEvent event,
  Emitter<ProfilePictureState> emit,
  ProfilePictureState state,
) {
  if (state is CameraLoadingState) {
    emit(
      CameraLoadedState(cameraController: state.cameraController),
    );
  } else {
    throw Exception("Invalid state: $state");
  }
}
