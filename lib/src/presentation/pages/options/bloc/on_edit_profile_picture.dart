part of options_page;

extension on _OptionsBloc {
  void onEditProfilePicture(
    _EditProfilePictureEvent event,
    Emitter<_OptionsState> emit,
  ) {
    emit(
      _EditProfilePictureState(
        onEditProfilePic: CancelableOperation.fromFuture(
          withAuth(
            (accessToken) => UseCases.uploadPhotoAuthorized(
              accessToken: accessToken,
              photo: event.newProfilePicture,
            ),
          ),
        )..then(
            (failure) => add(
              failure != null ? _ErrorEvent(failure) : const _SuccessEvent(),
            ),
          ),
      ),
    );
  }
}
