part of registration_page;

class _IGymsLoadedStateEvent extends _IRegistrationEvent {
  final List<GymEntity> gyms;
  final LocationEntity location;

  const _IGymsLoadedStateEvent(this.gyms, this.location) : super();
}
