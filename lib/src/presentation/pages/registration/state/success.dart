part of registration_page;

class _SuccessState extends _IRegistrationState {
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
}
