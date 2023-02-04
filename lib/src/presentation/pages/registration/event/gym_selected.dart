part of registration_page;

class _GymSelectedEvent extends _RegistrationEvent {
  final GymEntity gym;

  const _GymSelectedEvent(this.gym) : super();

  @override
  List<Object> get props => [gym];
}
