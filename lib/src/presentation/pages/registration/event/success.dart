part of registration_page;

class _SuccessEvent extends _RegistrationEvent {
  final RegisterResponse response;

  const _SuccessEvent(this.response) : super();

  @override
  List<Object> get props => [response];
}
