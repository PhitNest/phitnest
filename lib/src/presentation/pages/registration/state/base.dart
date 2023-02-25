part of registration_page;

abstract class _IRegistrationState {
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
}
