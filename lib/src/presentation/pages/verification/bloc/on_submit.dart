part of verification_page;

extension _OnSubmit on _VerificationBloc {
  void onSubmit(
    _SubmitEvent event,
    Emitter<_IVerificationState> emit,
  ) {
    if (codeController.text.length != 6) {
      StyledErrorBanner.show(
        const Failure('', 'Please enter a valid code'),
      );
    } else {
      emit(
        _ConfirmingState(
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
