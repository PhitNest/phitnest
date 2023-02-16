part of profile_picture_page;

extension _OnCaptureError on _ProfilePictureBloc {
  void onCaptureError(
    _CaptureErrorEvent event,
    Emitter<_IProfilePictureState> emit,
  ) {
    if (state is _IInitializedState) {
      final state = this.state as _IInitializedState;
      emit(
        _CaptureErrorState(
          cameraController: state.cameraController,
          failure: event.failure,
        ),
      );
    } else {
      throw Exception("Invalid state: $state");
    }
  }
}
