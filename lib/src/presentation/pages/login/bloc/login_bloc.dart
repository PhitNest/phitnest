part of login_page;

class _LoginBloc extends Bloc<_ILoginEvent, _ILoginState> {
  /// Controls the state of the email text field.
  final emailController = TextEditingController();

  /// Controls the state of the password text field.
  final passwordController = TextEditingController();

  /// Validates the email and password fields together.
  final formKey = GlobalKey<FormState>();

  /// Control unit for the business logic of the [LoginPage] widget.
  ///
  /// **STATE MACHINE:**
  ///
  /// * **[_InitialState]**
  ///   * on *[_SubmitEvent]* ->
  ///       * *[_LoadingState]* if the form is validated correctly
  ///       * *[_InitialState]* with autovalidate mode on if the form is invalid
  ///
  /// * **[_LoadingState]**
  ///   * on *[_SuccessEvent]* -> *[_SuccessState]*
  ///   * on *[_CancelEvent]* -> *[_InitialState]*
  ///   * on *[_ErrorEvent]* ->
  ///       * *[_ConfirmingEmailState]* if [Failures.userNotConfirmed]
  ///       * *[_InitialState]* with an entry in invalidCredentials if [Failures.invalidPassword]
  ///       * *[_ErrorState]* otherwise
  ///
  /// * **[_ErrorState]**
  ///   * on *[_SubmitEvent]* -> *[_LoadingState]*
  ///   * on *[_CancelEvent]* -> *[_InitialState]*
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
    // Close error banner
    if (state is _ErrorState) {
      final state = this.state as _ErrorState;
      state.dismiss.complete();
    }
    // Dispose of email and password text field controllers
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}

extension _Bloc on BuildContext {
  _LoginBloc get bloc => read();

  /// Issue a submit event to the bloc.
  void submit() => bloc.add(const _SubmitEvent());

  /// Issue a cancel event to the bloc and push [ForgotPasswordPage] onto the navigation stack.
  void goToForgotPassword() {
    bloc.add(const _CancelEvent());
    Navigator.push(
      this,
      CupertinoPageRoute(
        builder: (context) => const ForgotPasswordPage(),
      ),
    );
  }

  /// Issue a cancel event to the bloc and push [RegistrationPage] onto the navigation stack.
  void goToRegistration() {
    bloc.add(const _CancelEvent());
    Navigator.push(
      this,
      CupertinoPageRoute(
        builder: (context) => const RegistrationPage(),
      ),
    );
  }
}
