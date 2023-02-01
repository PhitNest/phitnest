part of forgot_password_page;

class _LoadingState extends _ForgotPasswordState {
  final CancelableOperation<Failure?> forgotPassOperation;

  _LoadingState({
    required super.autovalidateMode,
    required this.forgotPassOperation,
  }) : super();

  @override
  List<Object> get props => [
        super.props,
        forgotPassOperation.isCompleted,
        forgotPassOperation.isCanceled
      ];
}
