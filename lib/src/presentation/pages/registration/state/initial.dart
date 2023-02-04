part of registration_page;

class _InitialState extends _RegistrationState {
  final CancelableOperation<LocationAndGymsResponse> loadGymsOp;

  const _InitialState({
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.autovalidateMode,
    required super.takenEmails,
    required this.loadGymsOp,
  }) : super();

  @override
  List<Object> get props => [super.props, loadGymsOp.value];
}
