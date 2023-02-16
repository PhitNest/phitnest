part of profile_picture_page;

extension _OnUpload on _ProfilePictureBloc {
  void onUpload(
    _UploadEvent event,
    Emitter<_IProfilePictureState> emit,
  ) {
    if (state is _ICapturedState) {
      final state = this.state as _ICapturedState;
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
