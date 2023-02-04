part of registration_page;

class _EditFirstNameEvent extends _RegistrationEvent {
  final String? firstName;

  const _EditFirstNameEvent(this.firstName) : super();

  @override
  List<Object> get props => [firstName ?? ""];
}
