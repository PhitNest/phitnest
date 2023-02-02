part of profile_picture_page;

extension on _ProfilePictureBloc {
  void onUploadError(
    _UploadErrorEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Captured) {
      final capturedState = state as _Captured;
      emit(
        _UploadErrorState(
          cameraController: capturedState.cameraController,
          failure: event.failure,
          file: capturedState.file,
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
