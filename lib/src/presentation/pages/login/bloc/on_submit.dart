part of login_page;

extension _OnSubmit on _LoginBloc {
  /// The [_SubmitEvent] is issued when the user presses the submit button.
  void onSubmit(
    _SubmitEvent event,
    Emitter<_ILoginState> emit,
  ) async {
    // Close the error banner.
    if (state is _ErrorState) {
      final state = this.state as _ErrorState;
      state.dismiss.complete(null);
    }
    // Validate the email and password fields.
    if (formKey.currentState!.validate()) {
      // Transition to the loading state.
      emit(
        _LoadingState(
          autovalidateMode: AutovalidateMode.always,
          invalidCredentials: state.invalidCredentials,
          // Start the login operation.
          loginOperation: CancelableOperation.fromFuture(
            Repositories.auth.login(
              email: emailController.text.trim(),
              password: passwordController.text,
            ),
          )
            // When the login operation is complete, if it has not been cancelled,
            // issue either the success event or the error event depending on the response.
            ..then(
              (res) => add(
                res.fold(
                  (loginResponse) => _SuccessEvent(loginResponse),
                  (failure) => _ErrorEvent(failure),
                ),
              ),
            ),
        ),
      );
    } else {
      // Transition to the initial state but with autovalidate mode turned on.
      emit(
        _InitialState(
          autovalidateMode: AutovalidateMode.always,
          invalidCredentials: state.invalidCredentials,
        ),
      );
    }
  }
}
