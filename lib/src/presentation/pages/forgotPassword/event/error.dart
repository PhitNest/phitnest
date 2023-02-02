part of forgot_password_page;

class _ErrorEvent extends _ForgotPasswordEvent {
  final Failure failure;

  const _ErrorEvent(this.failure) : super();

  @override
  List<Object> get props => [failure];
}
