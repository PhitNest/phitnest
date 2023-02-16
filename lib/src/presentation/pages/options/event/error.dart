part of options_page;

class _ErrorEvent extends _IOptionsEvent {
  final Failure failure;

  const _ErrorEvent({
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [failure];
}
