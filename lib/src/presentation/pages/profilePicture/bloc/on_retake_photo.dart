part of profile_picture_page;

extension _OnRetakePhoto on _ProfilePictureBloc {
  void onRetakePhoto(
    _RetakePhotoEvent event,
    Emitter<_IProfilePictureState> emit,
  ) {
    if (state is _IInitializedState) {
      final state = this.state as _IInitializedState;
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
