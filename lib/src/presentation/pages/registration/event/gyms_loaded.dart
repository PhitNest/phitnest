part of registration_page;

class _GymsLoadedEvent extends _RegistrationEvent {
  final List<GymEntity> gyms;
  final LocationEntity location;

  const _GymsLoadedEvent(this.gyms, this.location) : super();

  @override
  List<Object> get props => [gyms, location];
}
