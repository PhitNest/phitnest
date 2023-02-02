part of profile_picture_page;

class _ProfilePictureBloc
    extends Bloc<_ProfilePictureEvent, _ProfilePictureState> {
  final XFile? initialImage;
  final Future<Failure?> Function(XFile image) uploadImage;

  _ProfilePictureBloc({
    required this.uploadImage,
    this.initialImage,
  }) : super(
          _InitialState(
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
    if (state is _InitialState) {
      final initialState = state as _InitialState;
      initialState.getFrontCamera.value.then((cameraDescription) =>
          add(_InitializeCameraEvent(cameraDescription)));
    }
    on<_InitializeCameraEvent>(onInitializeCamera);
    on<_RetryInitializeCameraEvent>(onRetryInitializeCamera);
    on<_CameraLoadedEvent>(onCameraLoaded);
    on<_CameraErrorEvent>(onCameraError);
    on<_CaptureEvent>(onCapture);
    on<_CaptureErrorEvent>(onCaptureError);
    on<_CaptureSuccessEvent>(onCaptureSuccess);
    on<_RetakePhotoEvent>(onRetakePhoto);
    on<_UploadEvent>(onUpload);
    on<_UploadErrorEvent>(onUploadError);
    on<_UploadSuccessEvent>(onUploadSuccess);
  }

  @override
  Future<void> close() async {
    if (state is _UploadingState) {
      final uploadingState = state as _UploadingState;
      await uploadingState.uploadImage.cancel();
    }
    if (state is _InitialState) {
      final initialState = state as _InitialState;
      await initialState.getFrontCamera.cancel();
    }
    if (state is _Initialized) {
      final initializedState = state as _Initialized;
      await initializedState.cameraController.dispose();
    }
    if (state is _CaptureLoadingState) {
      final captureLoadingState = state as _CaptureLoadingState;
      await captureLoadingState.captureImage.cancel();
    }
    if (state is _CameraLoadingState) {
      final cameraLoadingState = state as _CameraLoadingState;
      await cameraLoadingState.initializeCamera.cancel();
    }
    return super.close();
  }
}
