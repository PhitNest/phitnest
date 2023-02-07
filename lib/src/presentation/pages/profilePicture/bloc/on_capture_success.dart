part of profile_picture_page;

extension _OnCaptureSuccess on _ProfilePictureBloc {
  void onCaptureSuccess(
    _CaptureSuccessEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Initialized) {
      final state = this.state as _Initialized;
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
