part of verification_page;

extension _OnConfirmError on _VerificationBloc {
  void onConfirmError(
    _ErrorEvent event,
    Emitter<_IVerificationState> emit,
  ) =>
      emit(
        event.failure == Failures.profilePictureNotFound.instance
            ? const _ProfilePictureUploadState()
            : _ErrorState(
                banner: StyledErrorBanner(failure: event.failure),
              ),
      );
}
