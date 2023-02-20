part of registration_page;

class _RegisterErrorState extends _IGymSelectedState {
  final StyledErrorBanner banner;

  const _RegisterErrorState({
    required super.autovalidateMode,
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.gym,
    required super.gyms,
    required super.location,
    required super.takenEmails,
    required this.banner,
  }) : super();

  @override
  List<Object> get props => [super.props, banner];
}
