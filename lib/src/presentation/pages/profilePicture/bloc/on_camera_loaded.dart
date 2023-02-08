part of profile_picture_page;

extension _OnCameraLoaded on _ProfilePictureBloc {
  void onCameraLoaded(
    _CameraLoadedEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _CameraLoadingState) {
      final state = this.state as _CameraLoadingState;
      emit(
        _CameraLoadedState(
          cameraController: state.cameraController..setFlashMode(FlashMode.off),
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
