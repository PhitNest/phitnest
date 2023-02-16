part of profile_picture_page;

extension _OnUploadError on _ProfilePictureBloc {
  void onUploadError(
    _UploadErrorEvent event,
    Emitter<_IProfilePictureState> emit,
  ) {
    if (state is _ICapturedState) {
      final state = this.state as _ICapturedState;
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
