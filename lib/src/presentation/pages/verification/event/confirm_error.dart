part of verification_page;

class _ConfirmErrorEvent extends _IVerificationEvent {
  final Failure failure;

  const _ConfirmErrorEvent(this.failure) : super();

  @override
  List<Object> get props => [failure];
}
