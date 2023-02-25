part of verification_page;

class _LoginLoadingState extends _IVerificationState {
  final CancelableOperation<Either<LoginResponse, Failure>> login;

  const _LoginLoadingState({
    required this.login,
  }) : super();
}
