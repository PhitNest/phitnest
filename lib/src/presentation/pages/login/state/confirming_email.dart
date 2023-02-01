part of login_page;

class _ConfirmingEmailState extends _LoginState {
  final String email;
  final String password;

  const _ConfirmingEmailState({
    required super.autovalidateMode,
    required super.invalidCredentials,
    required this.email,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [super.props, email, password];
}
