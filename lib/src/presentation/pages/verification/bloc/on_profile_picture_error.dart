part of verification_page;

extension _OnProfilePictureError on _VerificationBloc {
  void onProfilePictureError(
    _ProfilePictureErrorEvent event,
    Emitter<_IVerificationState> emit,
  ) =>
      emit(const _ProfilePictureUploadState());
}
