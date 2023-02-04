part of registration_page;

class _GymSelectedState extends _GymSelected {
  const _GymSelectedState({
    required super.firstNameConfirmed,
    required super.location,
    required super.gyms,
    required super.currentPage,
    required super.autovalidateMode,
    required super.gym,
    required super.takenEmails,
  }) : super();

  @override
  List<Object> get props => [super.props, gym, takenEmails];
}
