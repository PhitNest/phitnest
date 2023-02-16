part of profile_picture_page;

extension _OnUploadSuccess on _ProfilePictureBloc {
  void onUploadSuccess(
    _UploadSuccessEvent event,
    Emitter<_IProfilePictureState> emit,
  ) {
    if (state is _ICapturedState) {
      final state = this.state as _ICapturedState;
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
