part of login_page;

class _LoadingState extends _ILoginState {
  final CancelableOperation<Either<LoginResponse, Failure>> loginOperation;

  const _LoadingState({
    required super.autovalidateMode,
    required super.invalidCredentials,
    required this.loginOperation,
  }) : super();

  @override
  List<Object> get props => [super.props, loginOperation.value];
}
