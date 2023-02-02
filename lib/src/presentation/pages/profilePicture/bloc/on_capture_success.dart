part of profile_picture_page;

extension on _ProfilePictureBloc {
  void onCaptureSuccess(
    _CaptureSuccessEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Initialized) {
      final initializedState = state as _Initialized;
      emit(
        _CaptureSuccessState(
          cameraController: initializedState.cameraController,
          file: event.file,
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
