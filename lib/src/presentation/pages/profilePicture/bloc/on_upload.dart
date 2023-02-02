part of profile_picture_page;

extension on _ProfilePictureBloc {
  void onUpload(
    _UploadEvent event,
    Emitter<_ProfilePictureState> emit,
  ) {
    if (state is _Captured) {
      final capturedState = state as _Captured;
      emit(
        _UploadingState(
          cameraController: capturedState.cameraController,
          file: capturedState.file,
          uploadImage:
              CancelableOperation.fromFuture(uploadImage(capturedState.file))
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
