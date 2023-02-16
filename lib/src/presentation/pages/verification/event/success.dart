part of verification_page;

class _SuccessEvent extends _IVerificationEvent {
  final LoginResponse? response;

  const _SuccessEvent(this.response) : super();

  @override
  List<Object> get props => [response ?? ""];
}
