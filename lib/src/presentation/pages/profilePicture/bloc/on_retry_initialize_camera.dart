part of profile_picture_page;

extension on _ProfilePictureBloc {
  void onRetryInitializeCamera(
    _RetryInitializeCameraEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Initialized) {
      final initializedState = state as _Initialized;
      emit(
        _CameraLoadingState(
          cameraController: initializedState.cameraController,
          initializeCamera: CancelableOperation.fromFuture(
            initializedState.cameraController
                .initialize()
                .then<Failure?>((_) => null)
                .catchError(
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
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
