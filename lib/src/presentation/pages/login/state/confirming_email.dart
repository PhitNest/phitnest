part of login_page;

class _ConfirmingEmailState extends _ILoginState {
  final String email;
  final String password;

  /// This state indicates that we are waiting for the user to complete the [ConfirmEmailPage].
  /// If they do not complete it, they will still be in this state until the next [_SubmitEvent]
  /// or [_CancelEvent].
  ///
  /// [email] and [password] are used to login from the [ConfirmEmailPage] after the user has
  /// confirmed their email.
  const _ConfirmingEmailState({
    required super.autovalidateMode,
    required super.invalidCredentials,
    required this.email,
    required this.password,
  }) : super();
}
