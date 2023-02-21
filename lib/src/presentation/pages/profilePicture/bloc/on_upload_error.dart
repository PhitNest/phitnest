part of profile_picture_page;

extension _OnUploadError on _ProfilePictureBloc {
  void onUploadError(
    _UploadErrorEvent event,
    Emitter<_IProfilePictureState> emit,
  ) {
    if (state is _ICapturedState) {
      final state = this.state as _ICapturedState;
      StyledErrorBanner.show(event.failure);
      emit(
        _CaptureSuccessState(
          cameraController: state.cameraController,
          file: state.file,
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
