import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/profile_picture_event.dart';
import '../state/profile_picture_state.dart';

void onUploadSuccess(
  UploadSuccessEvent event,
  Emitter<ProfilePictureState> emit,
  ProfilePictureState state,
) {
  if (state is UploadingState) {
    emit(
      UploadSuccessState(
        cameraController: state.cameraController,
        file: state.file,
      ),
    );
  } else {
    throw Exception("Invalid state: $state");
  }
}
