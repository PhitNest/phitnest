part of profile_picture_page;

extension _OnInitializeCamera on _ProfilePictureBloc {
  void onInitializeCamera(
    _InitializeCameraEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    final cameraController = CameraController(
      event.cameraDescription,
      ResolutionPreset.max,
      enableAudio: false,
    )..setFlashMode(FlashMode.off);
    emit(
      _CameraLoadingState(
        cameraController: cameraController,
        initializeCamera: CancelableOperation.fromFuture(
          cameraController.initialize().then<Failure?>((_) => null).catchError(
                (error) async =>
                    Failure(error.code, error.description ?? "Camera error"),
              ),
        )..then(
            (failure) => failure != null
                ? add(_CameraErrorEvent(failure))
                : add(
                    initialImage != null
                        ? _CaptureSuccessEvent(initialImage!)
                        : const _CameraLoadedEvent(),
                  ),
          ),
      ),
    );
  }
}
