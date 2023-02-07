part of verification_page;

extension _OnProfilePictureError on _VerificationBloc {
  void onProfilePictureError(
    _ProfilePictureErrorEvent event,
    Emitter<_VerificationState> emit,
  ) =>
      emit(const _ProfilePictureUploadState());
}
