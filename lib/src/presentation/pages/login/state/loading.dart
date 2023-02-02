part of login_page;

class _LoadingState extends _LoginState {
  final CancelableOperation loginOperation;

  const _LoadingState({
    required super.autovalidateMode,
    required super.invalidCredentials,
    required this.loginOperation,
  }) : super();

  @override
  List<Object> get props => [
        super.props,
        loginOperation.isCanceled,
        loginOperation.isCompleted,
      ];
}
