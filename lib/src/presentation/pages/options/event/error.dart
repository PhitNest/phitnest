part of options_page;

class _ErrorEvent extends _OptionsEvent {
  final Failure failure;

  const _ErrorEvent({
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [failure];
}
