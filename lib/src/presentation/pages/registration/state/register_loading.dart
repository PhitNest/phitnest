part of registration_page;

class _RegisterLoadingState extends _IGymSelectedState {
  final CancelableOperation<Either<RegisterResponse, Failure>> registerOp;

  const _RegisterLoadingState({
    required super.autovalidateMode,
    required super.gym,
    required super.gyms,
    required super.takenEmails,
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.location,
    required this.registerOp,
  }) : super();
}
