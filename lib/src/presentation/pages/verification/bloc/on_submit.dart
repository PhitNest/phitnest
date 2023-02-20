part of verification_page;

extension _OnSubmit on _VerificationBloc {
  void onSubmit(
    _SubmitEvent event,
    Emitter<_IVerificationState> emit,
  ) {
    if (state is _ErrorState ||
        state is _InitialState ||
        state is _ProfilePictureUploadState) {
      if (state is _ErrorState) {
        final state = this.state as _ErrorState;
        state.banner.dismiss();
      }
      emit(
        codeController.text.length != 6
            ? _ErrorState(
                banner:
                    StyledErrorBanner(failure: Failures.invalidCode.instance),
              )
            : _ConfirmingState(
                confirm: CancelableOperation.fromFuture(
                  confirm(
                    codeController.text,
                  )..then(
                      (failure) => add(
                        failure != null
                            ? _ErrorEvent(failure)
                            : const _ConfirmSuccessEvent(),
                      ),
                    ),
                ),
              ),
      );
    }
  }
}
