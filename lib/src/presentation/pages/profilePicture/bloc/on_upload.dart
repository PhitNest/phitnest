part of profile_picture_page;

extension on _ProfilePictureBloc {
  void onUpload(
    _UploadEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Captured) {
      final state = this.state as _Captured;
      emit(
        _UploadingState(
          cameraController: state.cameraController,
          file: state.file,
          uploadImage: CancelableOperation.fromFuture(uploadImage(state.file))
            ..then(
              (failure) => add(
                failure != null
                    ? _UploadErrorEvent(failure)
                    : const _UploadSuccessEvent(),
              ),
            ),
        ),
      );
    } else {
      throw Exception('Invalid state: $state');
    }
  }
}
