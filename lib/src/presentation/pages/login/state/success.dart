part of login_page;

class _SuccessState extends _ILoginState {
  final LoginResponse response;

  const _SuccessState({
    required super.autovalidateMode,
    required super.invalidCredentials,
    required this.response,
  }) : super();
}
