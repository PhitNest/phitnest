part of registration_page;

abstract class _RegistrationState extends Equatable {
  final bool firstNameConfirmed;
  final int currentPage;
  final AutovalidateMode autovalidateMode;
  final Set<String> takenEmails;

  const _RegistrationState({
    required this.firstNameConfirmed,
    required this.currentPage,
    required this.autovalidateMode,
    required this.takenEmails,
  }) : super();

  @override
  List<Object> get props =>
      [firstNameConfirmed, currentPage, autovalidateMode, takenEmails];
}

abstract class _GymsLoaded extends _RegistrationState {
  final LocationEntity location;
  final List<GymEntity> gyms;

  const _GymsLoaded({
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.autovalidateMode,
    required super.takenEmails,
    required this.location,
    required this.gyms,
  }) : super();

  @override
  List<Object> get props => [super.props, location, gyms];
}

abstract class _GymSelected extends _GymsLoaded {
  final GymEntity gym;

  const _GymSelected({
    required super.firstNameConfirmed,
    required super.location,
    required super.gyms,
    required super.currentPage,
    required super.autovalidateMode,
    required super.takenEmails,
    required this.gym,
  }) : super();

  @override
  List<Object> get props => [super.props, gym];
}
