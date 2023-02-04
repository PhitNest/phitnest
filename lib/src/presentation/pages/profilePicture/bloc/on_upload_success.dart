part of profile_picture_page;

extension on _ProfilePictureBloc {
  void onUploadSuccess(
    _UploadSuccessEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Captured) {
      final state = this.state as _Captured;
      emit(
        _UploadSuccessState(
          cameraController: state.cameraController,
          file: state.file,
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
