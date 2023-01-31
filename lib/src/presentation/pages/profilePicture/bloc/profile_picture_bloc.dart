import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/failure.dart';
import '../event/profile_picture_event.dart';
import '../state/profile_picture_state.dart';
import 'on_camera_error.dart';
import 'on_camera_loaded.dart';
import 'on_capture.dart';
import 'on_capture_error.dart';
import 'on_capture_success.dart';
import 'on_initialized.dart';
import 'on_retake_photo.dart';
import 'on_retry_initialize_camera.dart';
import 'on_upload.dart';
import 'on_upload_error.dart';
import 'on_upload_success.dart';

class ProfilePictureBloc
    extends Bloc<ProfilePictureEvent, ProfilePictureState> {
  ProfilePictureBloc({
    required Future<Failure?> Function(XFile image) uploadImage,
    XFile? initialImage,
  }) : super(
          InitialState(
            getFrontCamera: CancelableOperation.fromFuture(
              availableCameras().then(
                (cameras) => cameras.firstWhere(
                  (element) =>
                      element.lensDirection == CameraLensDirection.front,
                  orElse: () => cameras.first,
                ),
              ),
            ),
          ),
        ) {
    if (state is InitialState) {
      final initialState = state as InitialState;
      initialState.getFrontCamera.value.then(
          (cameraDescription) => add(InitializedEvent(cameraDescription)));
    }
    on<InitializedEvent>(
        (event, emit) => onInitialized(event, emit, state, add, initialImage));
    on<CameraLoadedEvent>((event, emit) => onCameraLoaded(event, emit, state));
    on<CameraErrorEvent>((event, emit) => onCameraError(event, emit, state));
    on<CaptureEvent>((event, emit) => onCapture(event, emit, state, add));
    on<CaptureErrorEvent>((event, emit) => onCaptureError(event, emit, state));
    on<CaptureSuccessEvent>(
        (event, emit) => onCaptureSuccess(event, emit, state));
    on<RetakePhotoEvent>((event, emit) => onRetakePhoto(event, emit, state));
    on<RetryInitializeCameraEvent>((event, emit) =>
        onRetryInitializeCamera(event, emit, state, add, initialImage));
    on<UploadEvent>(
        (event, emit) => onUpload(event, emit, state, add, uploadImage));
    on<UploadErrorEvent>((event, emit) => onUploadError(event, emit, state));
    on<UploadSuccessEvent>(
        (event, emit) => onUploadSuccess(event, emit, state));
  }

  @override
  Future<void> close() async {
    if (state is UploadingState) {
      final uploadingState = state as UploadingState;
      await uploadingState.uploadImage.cancel();
    }
    if (state is InitialState) {
      final initialState = state as InitialState;
      await initialState.getFrontCamera.cancel();
    }
    if (state is InitializedState) {
      final initializedState = state as InitializedState;
      await initializedState.cameraController.dispose();
    }
    if (state is CaptureLoadingState) {
      final captureLoadingState = state as CaptureLoadingState;
      await captureLoadingState.captureImage.cancel();
    }
    if (state is CameraLoadingState) {
      final cameraLoadingState = state as CameraLoadingState;
      await cameraLoadingState.initializeCamera.cancel();
    }
    return super.close();
  }
}
