part of registration_page;

class _SuccessState extends _RegistrationState {
  final RegisterResponse response;
  final String password;

  const _SuccessState({
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.autovalidateMode,
    required super.takenEmails,
    required this.response,
    required this.password,
  }) : super();

  @override
  List<Object> get props => [super.props, response, password];
}
