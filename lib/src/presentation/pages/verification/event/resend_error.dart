part of verification_page;

class _ResendErrorEvent extends _IVerificationEvent {
  final Failure failure;

  const _ResendErrorEvent(this.failure) : super();

  @override
  List<Object> get props => [failure];
}
