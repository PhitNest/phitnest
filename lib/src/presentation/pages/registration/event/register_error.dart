part of registration_page;

class _RegisterErrorEvent extends _IRegistrationEvent {
  final Failure failure;

  const _RegisterErrorEvent(this.failure) : super();
}
