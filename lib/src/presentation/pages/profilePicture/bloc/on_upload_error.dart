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
          file: state.file,
          errorBanner: StyledErrorBanner(
            failure: event.failure,
          ),
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
