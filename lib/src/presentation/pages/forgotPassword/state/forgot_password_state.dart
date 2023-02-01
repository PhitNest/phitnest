part of forgot_password_page;

abstract class _ForgotPasswordState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const _ForgotPasswordState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object> get props => [autovalidateMode];
}
