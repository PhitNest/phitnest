part of profile_picture_page;

extension _OnCameraError on _ProfilePictureBloc {
  void onCameraError(
    _CameraErrorEvent event,
    Emitter<_IProfilePictureState> emit,
  ) {
    if (state is _CameraLoadingState) {
      final state = this.state as _CameraLoadingState;
      emit(
        _CameraErrorState(
          cameraController: state.cameraController,
          failure: event.failure,
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
