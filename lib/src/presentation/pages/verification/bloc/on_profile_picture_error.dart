part of verification_page;

extension on _VerificationBloc {
  void onProfilePictureError(
    _ProfilePictureErrorEvent event,
    Emitter<_VerificationState> emit,
  ) =>
      emit(const _ProfilePictureUploadState());
}
