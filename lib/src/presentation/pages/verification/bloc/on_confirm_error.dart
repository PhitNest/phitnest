part of verification_page;

extension _OnConfirmError on _VerificationBloc {
  void onConfirmError(
    _ErrorEvent event,
    Emitter<_IVerificationState> emit,
  ) {
    if (event.failure == Failures.profilePictureNotFound.instance) {
      emit(const _ProfilePictureUploadState());
    } else {
      StyledErrorBanner.show(event.failure);
      emit(const _InitialState());
    }
  }
}
