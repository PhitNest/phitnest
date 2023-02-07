part of profile_picture_page;

extension _OnCapture on _ProfilePictureBloc {
  void onCapture(
    _CaptureEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Initialized) {
      final state = this.state as _Initialized;
      emit(
        _CaptureLoadingState(
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
                (file) => add(_CaptureSuccessEvent(file)),
                (failure) => add(_CaptureErrorEvent(failure)),
              ),
            ),
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
