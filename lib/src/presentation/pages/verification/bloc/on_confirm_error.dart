part of verification_page;

extension _OnConfirmError on _VerificationBloc {
  void onConfirmError(
    _ConfirmErrorEvent event,
    Emitter<_VerificationState> emit,
  ) =>
      emit(
        checkProfilePicture &&
                event.failure == Failures.profilePictureNotFound.instance
            ? const _ProfilePictureUploadState()
            : _ConfirmErrorState(failure: event.failure),
      );
}
