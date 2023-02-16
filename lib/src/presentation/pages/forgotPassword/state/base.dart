part of forgot_password_page;

abstract class _IForgotPasswordState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const _IForgotPasswordState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object> get props => [autovalidateMode];
}
