part of login_page;

class _LoginBloc extends Bloc<_ILoginEvent, _ILoginState> {
  /// Controls the state of the email text field.
  final emailController = TextEditingController();

  /// Controls the state of the password text field.
  final passwordController = TextEditingController();

  /// Validates the email and password fields together.
  final formKey = GlobalKey<FormState>();

  final emailFocus = FocusNode();

  final passwordFocus = FocusNode();

  /// Control unit for the business logic of the [LoginPage] widget.
  ///
  /// **STATE MACHINE:**
  ///
  /// * **[_InitialState]**
  ///   * on *[_SubmitEvent]* ->
  ///     * *[_LoadingState]* if the form is validated correctly
  ///     * *[_InitialState]* with autovalidate mode on if the form is invalid
  ///
  /// * **[_LoadingState]**
  ///   * on *[_SuccessEvent]* -> *[_SuccessState]*
  ///   * on *[_CancelEvent]* -> *[_InitialState]*
  ///   * on *[_ErrorEvent]* ->
  ///     * *[_ConfirmingEmailState]* if [Failures.userNotConfirmed]
  ///     * *[_InitialState]* otherwise with an entry in invalidCredentials if [Failures.invalidPassword]
  ///
  /// * **[_ConfirmingEmailState]**
  ///   * on *[_SubmitEvent]* -> *[_LoadingState]*
  _LoginBloc()
      // INITIAL STATE
      : super(
          const _InitialState(
            autovalidateMode: AutovalidateMode.disabled,
            invalidCredentials: {},
          ),
        ) {
    // EVENT HANDLERS
    on<_SubmitEvent>(onSubmit);
    on<_SuccessEvent>(onSuccess);
    on<_ErrorEvent>(onLoginError);
    on<_CancelEvent>(onCancel);
  }

  /// Triggered when the user navigates way from this screen (pops it off the navigation stack)
  @override
  Future<void> close() {
    // Cancel loading operation
    if (state is _LoadingState) {
      final state = this.state as _LoadingState;
      state.loginOperation.cancel();
    }
    // Dispose of email and password text field controllers
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    return super.close();
  }
}

extension _Bloc on BuildContext {
  _LoginBloc get bloc => read();
}
