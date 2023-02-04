part of profile_picture_page;

extension on _ProfilePictureBloc {
  void onRetakePhoto(
    _RetakePhotoEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Initialized) {
      final state = this.state as _Initialized;
      emit(
        _CameraLoadedState(
          cameraController: state.cameraController,
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
