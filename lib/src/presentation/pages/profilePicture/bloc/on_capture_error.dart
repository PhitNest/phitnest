part of profile_picture_page;

extension _OnCaptureError on _ProfilePictureBloc {
  void onCaptureError(
    _CaptureErrorEvent event,
    Emitter<_IProfilePictureState> emit,
  ) {
    StyledErrorBanner.show(event.failure);
    final state = this.state as _IInitializedState;
    emit(_CameraLoadedState(cameraController: state.cameraController));
  }
}
