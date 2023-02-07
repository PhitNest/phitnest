part of profile_picture_page;

extension _OnUploadError on _ProfilePictureBloc {
  void onUploadError(
    _UploadErrorEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Captured) {
      final state = this.state as _Captured;
      emit(
        _UploadErrorState(
          cameraController: state.cameraController,
          failure: event.failure,
          file: state.file,
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
