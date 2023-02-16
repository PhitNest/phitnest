part of profile_picture_page;

class _ProfilePictureBloc
    extends Bloc<_IProfilePictureEvent, _IProfilePictureState> {
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
      final state = this.state as _InitialState;
      state.getFrontCamera.value.then((cameraDescription) =>
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
      final state = this.state as _UploadingState;
      await state.uploadImage.cancel();
    }
    if (state is _InitialState) {
      final state = this.state as _InitialState;
      await state.getFrontCamera.cancel();
    }
    if (state is _CameraLoadedState) {
      final state = this.state as _CameraLoadedState;
      await state.cameraController.dispose();
    }
    if (state is _CameraErrorState) {
      final state = this.state as _CameraErrorState;
      await state.cameraController.dispose();
    }
    if (state is _IInitializedState) {
      final state = this.state as _IInitializedState;
      await state.cameraController.dispose();
    }
    if (state is _CaptureLoadingState) {
      final state = this.state as _CaptureLoadingState;
      await state.captureImage.cancel();
    }
    if (state is _CameraLoadingState) {
      final state = this.state as _CameraLoadingState;
      await state.initializeCamera.cancel();
    }
    return super.close();
  }
}
