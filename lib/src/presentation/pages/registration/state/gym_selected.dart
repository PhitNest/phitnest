part of registration_page;

class _IGymSelectedStateState extends _IGymSelectedState {
  const _IGymSelectedStateState({
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
