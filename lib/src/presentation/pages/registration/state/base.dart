part of registration_page;

abstract class _IRegistrationState extends Equatable {
  final bool firstNameConfirmed;
  final int currentPage;
  final AutovalidateMode autovalidateMode;
  final Set<String> takenEmails;

  const _IRegistrationState({
    required this.firstNameConfirmed,
    required this.currentPage,
    required this.autovalidateMode,
    required this.takenEmails,
  }) : super();

  @override
  List<Object> get props =>
      [firstNameConfirmed, currentPage, autovalidateMode, takenEmails];
}

abstract class _IGymsLoadedState extends _IRegistrationState {
  final LocationEntity location;
  final List<GymEntity> gyms;

  const _IGymsLoadedState({
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

abstract class _IGymSelectedState extends _IGymsLoadedState {
  final GymEntity gym;

  const _IGymSelectedState({
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
