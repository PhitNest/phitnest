part of profile_picture_page;

extension on _ProfilePictureBloc {
  void onCaptureError(
    _CaptureErrorEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Initialized) {
      final initializedState = state as _Initialized;
      emit(
        _CaptureErrorState(
          cameraController: initializedState.cameraController,
          failure: event.failure,
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
