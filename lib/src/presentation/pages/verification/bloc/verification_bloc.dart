part of verification_page;

class _VerificationBloc extends Bloc<_IVerificationEvent, _IVerificationState> {
  final codeController = TextEditingController();
  final String email;
  final String? password;
  final bool shouldLogin;
  final Future<Failure?> Function(String code) confirm;
  final Future<Failure?> Function() resend;

  /// Control unit for the business logic of the [VerificationPage] widget.
  ///
  /// **STATE MACHINE:**
  ///
  /// * **[_InitialState]**
  ///   * on *[_SubmitEvent]* ->
  ///     * *[_ErrorState]* if the user has not entered a 6 digit code
  ///     * *[_ConfirmingState]* otherwise
  ///   * on *[_ResendEvent]* -> *[_ResendingState]*
  ///
  /// * **[_ConfirmingState]**
  ///   * on *[_ErrorEvent]* ->
  ///     * *[_ProfilePictureUploadState]* if [Failures.profilePictureNotFound]
  ///     * *[_ErrorState]* otherwise
  ///   * on *[_ConfirmSuccessEvent]* ->
  ///     * *[_LoginLoadingState]* if [shouldLogin] is true
  ///     * *[_SuccessState]* otherwise
  ///
  /// * **[_LoginLoadingState]**
  ///   * on *[_LoginResponseEvent]* -> *[_SuccessState]*
  ///
  /// * **[_ProfilePictureUploadState]**
  ///   * on *[_SubmitEvent]* ->
  ///     * *[_ErrorState]* if the user has not entered a 6 digit code
  ///     * *[_ConfirmingState]* otherwise
  ///   * on *[_ResendEvent]* -> *[_ResendingState]*
  ///
  /// * **[_ErrorState]**
  ///   * on *[_SubmitEvent]* ->
  ///     * *[_ErrorState]* if the user has not entered a 6 digit code
  ///     * *[_ConfirmingState]* otherwise
  ///   * on *[_ResendEvent]* -> *[_ResendingState]*
  ///
  /// * **[_ResendingState]**
  ///   * on *[_ErrorEvent]* -> *[_ErrorState]*
  ///   * on *[_ResetEvent]* -> *[_InitialState]*
  _VerificationBloc({
    required this.email,
    required this.confirm,
    required this.resend,
    required this.password,
    required this.shouldLogin,
  }) : super(const _InitialState()) {
    on<_SubmitEvent>(onSubmit);
    on<_LoginResponseEvent>(onLoginResponse);
    on<_ConfirmSuccessEvent>(onConfirmSuccess);
    on<_ErrorEvent>(onConfirmError);
    on<_ResendEvent>(onResend);
    on<_ResetEvent>(onReset);
  }

  @override
  Future<void> close() async {
    if (state is _ConfirmingState) {
      final state = this.state as _ConfirmingState;
      await state.confirm.cancel();
    }
    if (state is _ErrorState) {
      final state = this.state as _ErrorState;
      state.dismiss.complete();
    }
    if (state is _LoginLoadingState) {
      final state = this.state as _LoginLoadingState;
      await state.login.cancel();
    }
    if (state is _ResendingState) {
      final state = this.state as _ResendingState;
      await state.resend.cancel();
    }
    codeController.dispose();
    return super.close();
  }
}

extension _Bloc on BuildContext {
  _VerificationBloc get bloc => read();
}
