import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/profile_picture_event.dart';
import '../state/profile_picture_state.dart';

void onUploadError(
  UploadErrorEvent event,
  Emitter<ProfilePictureState> emit,
  ProfilePictureState state,
) {
  if (state is UploadingState) {
    emit(
      UploadErrorState(
        cameraController: state.cameraController,
        failure: event.failure,
        file: state.file,
      ),
    );
  } else {
    throw Exception("Invalid state: $state");
  }
}
