part of profile_picture_page;

extension on _ProfilePictureBloc {
  void onCameraLoaded(
    _CameraLoadedEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Initialized) {
      final initializedState = state as _Initialized;
      emit(
        _CameraLoadedState(
          cameraController: initializedState.cameraController,
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
