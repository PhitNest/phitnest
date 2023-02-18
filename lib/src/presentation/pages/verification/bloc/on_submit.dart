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
        state.dismiss.complete();
      }
      emit(
        codeController.text.length != 6
            ? _ErrorState(
                failure: Failures.invalidCode.instance,
                dismiss: Completer(),
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
