part of verification_page;

extension on _VerificationBloc {
  void onSubmit(
    _SubmitEvent event,
    Emitter<_VerificationState> emit,
  ) =>
      emit(
        codeController.text.length != 6
            ? _ConfirmErrorState(failure: Failures.invalidCode.instance)
            : _ConfirmingState(
                operation: CancelableOperation.fromFuture(
                  event.confirmation(
                    codeController.text,
                  )..then(
                      (either) => either.fold(
                        (response) => add(_SuccessEvent(response)),
                        (failure) => add(_ConfirmErrorEvent(failure)),
                      ),
                    ),
                ),
              ),
      );
}
