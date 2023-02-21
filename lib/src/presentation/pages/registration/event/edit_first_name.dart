part of registration_page;

class _EditFirstNameEvent extends _IRegistrationEvent {
  final String? firstName;

  const _EditFirstNameEvent(this.firstName) : super();
}
