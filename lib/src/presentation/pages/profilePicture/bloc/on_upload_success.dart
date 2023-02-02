part of profile_picture_page;

extension on _ProfilePictureBloc {
  void onUploadSuccess(
    _UploadSuccessEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Captured) {
      final capturedState = state as _Captured;
      emit(
        _UploadSuccessState(
          cameraController: capturedState.cameraController,
          file: capturedState.file,
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
