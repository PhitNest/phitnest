part of verification_page;

class _SubmitEvent extends _IVerificationEvent {
  final Future<Either<LoginResponse?, Failure>> Function(String code)
      confirmation;

  const _SubmitEvent({
    required this.confirmation,
  }) : super();

  @override
  List<Object> get props => [confirmation];
}
