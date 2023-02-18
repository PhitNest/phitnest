part of verification_page;

extension _OnConfirmSuccess on _VerificationBloc {
  void onConfirmSuccess(
    _ConfirmSuccessEvent event,
    Emitter<_IVerificationState> emit,
  ) =>
      emit(
        shouldLogin
            ? _LoginLoadingState(
                login: CancelableOperation.fromFuture(
                  Repositories.auth.login(
                    email: email,
                    password: password!,
                  ),
                )..then(
                    (response) => add(
                      _LoginResponseEvent(
                        response.fold(
                          (response) => response,
                          (failure) => null,
                        ),
                      ),
                    ),
                  ),
              )
            : const _SuccessState(response: null),
      );
}
