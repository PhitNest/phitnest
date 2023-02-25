part of forgot_password_page;

class _LoadingState extends _IForgotPasswordState {
  final CancelableOperation<Failure?> forgotPassOperation;

  _LoadingState({
    required super.autovalidateMode,
    required this.forgotPassOperation,
  }) : super();
}
