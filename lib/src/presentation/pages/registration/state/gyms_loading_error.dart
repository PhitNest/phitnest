part of registration_page;

class _GymsLoadingErrorState extends _RegistrationState {
  final Failure failure;

  const _GymsLoadingErrorState({
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.autovalidateMode,
    required super.takenEmails,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}
