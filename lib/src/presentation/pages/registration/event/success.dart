part of registration_page;

class _SuccessEvent extends _IRegistrationEvent {
  final RegisterResponse response;

  const _SuccessEvent(this.response) : super();
}
