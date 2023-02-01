part of login_page;

class _SuccessState extends _LoginState {
  final LoginResponse response;
  final String password;

  const _SuccessState({
    required super.autovalidateMode,
    required super.invalidCredentials,
    required this.response,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [response];
}
