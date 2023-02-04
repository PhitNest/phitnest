part of registration_page;

/// This event is emitted if there is an error loading gyms
class _GymsLoadingErrorEvent extends _RegistrationEvent {
  final Failure failure;

  const _GymsLoadingErrorEvent(this.failure) : super();

  @override
  List<Object> get props => [failure];
}
