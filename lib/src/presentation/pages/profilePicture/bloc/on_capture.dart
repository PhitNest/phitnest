import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/utils.dart';
import '../../../../common/failure.dart';
import '../event/profile_picture_event.dart';
import '../state/profile_picture_state.dart';

void onCapture(
  CaptureEvent event,
  Emitter<ProfilePictureState> emit,
  ProfilePictureState state,
  ValueChanged<ProfilePictureEvent> add,
) {
  if (state is CameraLoadedState) {
    emit(
      CaptureLoadingState(
        cameraController: state.cameraController,
        captureImage: CancelableOperation.fromFuture(
          state.cameraController
              .takeProfilePicture()
              .then<Either<XFile, Failure>>((file) => Left(file))
              .catchError(
                (err) => Right<XFile, Failure>(
                    Failure(err.code, err.description ?? "Capture error")),
              ),
        )..then(
            (either) => either.fold(
              (file) => add(CaptureSuccessEvent(file)),
              (failure) => add(CaptureErrorEvent(failure)),
            ),
          ),
      ),
    );
  } else {
    throw Exception("Invalid state: $state");
  }
}
