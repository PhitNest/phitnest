part of profile_picture_page;

extension _OnCaptureSuccess on _ProfilePictureBloc {
  void onCaptureSuccess(
    _CaptureSuccessEvent event,
    Emitter<_IProfilePictureState> emit,
  ) {
    if (state is _IInitializedState) {
      final state = this.state as _IInitializedState;
      emit(
        _CaptureSuccessState(
          cameraController: state.cameraController,
          file: event.file,
        ),
      );
    } else if (state is _CameraLoadingState) {
      final state = this.state as _CameraLoadingState;
      emit(
        _CaptureSuccessState(
          cameraController: state.cameraController,
          file: event.file,
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
