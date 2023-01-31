import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/failure.dart';
import '../event/profile_picture_event.dart';
import '../state/profile_picture_state.dart';

void onUpload(
  UploadEvent event,
  Emitter<ProfilePictureState> emit,
  ProfilePictureState state,
  ValueChanged<ProfilePictureEvent> add,
  Future<Failure?> Function(XFile image) uploadImage,
) {
  if (state is CaptureSuccessState) {
    emit(
      UploadingState(
        cameraController: state.cameraController,
        file: state.file,
        uploadImage: CancelableOperation.fromFuture(uploadImage(state.file))
          ..then(
            (failure) => failure != null
                ? add(UploadErrorEvent(failure))
                : add(const UploadSuccessEvent()),
          ),
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
