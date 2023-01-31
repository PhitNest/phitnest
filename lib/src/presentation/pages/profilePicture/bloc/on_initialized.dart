import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/failure.dart';
import '../event/profile_picture_event.dart';
import '../state/profile_picture_state.dart';

void onInitialized(
  InitializedEvent event,
  Emitter<ProfilePictureState> emit,
  ProfilePictureState state,
  ValueChanged<ProfilePictureEvent> add,
  XFile? initialImage,
) {
  if (state is InitialState) {
    final cameraController = CameraController(
      event.cameraDescription,
      ResolutionPreset.max,
    );
    emit(
      CameraLoadingState(
        cameraController: cameraController,
        initializeCamera: CancelableOperation.fromFuture(
          cameraController.initialize().then<Failure?>((_) => null).catchError(
                (error) async =>
                    Failure(error.code, error.description ?? "Camera error"),
              ),
        )..then(
            (failure) => failure != null
                ? add(CameraErrorEvent(failure))
                : add(
                    initialImage != null
                        ? CaptureSuccessEvent(initialImage)
                        : CameraLoadedEvent(),
                  ),
          ),
      ),
    );
  } else {
    throw Exception("Invalid state: $state");
  }
}
