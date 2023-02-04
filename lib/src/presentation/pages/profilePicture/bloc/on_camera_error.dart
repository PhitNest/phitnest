part of profile_picture_page;

extension on _ProfilePictureBloc {
  void onCameraError(
    _CameraErrorEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Initialized) {
      final state = this.state as _Initialized;
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
