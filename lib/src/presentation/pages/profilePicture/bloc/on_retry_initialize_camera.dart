part of profile_picture_page;

extension _OnRetryInitializeCamera on _ProfilePictureBloc {
  void onRetryInitializeCamera(
    _RetryInitializeCameraEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _CameraErrorState) {
      final state = this.state as _CameraErrorState;
      emit(
        _CameraLoadingState(
          cameraController: state.cameraController,
          initializeCamera: CancelableOperation.fromFuture(
            state.cameraController
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
