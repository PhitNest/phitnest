part of profile_picture_page;

extension _OnCameraError on _ProfilePictureBloc {
  void onCameraError(
    _CameraErrorEvent event,
    Emitter<_IProfilePictureState> emit,
  ) {
    final state = this.state as _CameraLoadingState;
    StyledErrorBanner.show(event.failure);
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
  }
}
