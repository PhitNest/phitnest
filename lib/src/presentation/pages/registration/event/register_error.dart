part of registration_page;

class _RegisterErrorEvent extends _RegistrationEvent {
  final Failure failure;

  const _RegisterErrorEvent(this.failure) : super();

  @override
  List<Object> get props => [failure];
}
