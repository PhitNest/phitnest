part of registration_page;

class _IGymSelectedStateEvent extends _IRegistrationEvent {
  final GymEntity gym;

  const _IGymSelectedStateEvent(this.gym) : super();
}
