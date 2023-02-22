part of home_page;

class _OptionsErrorEvent extends _IOptionsEvent {
  final Failure failure;

  const _OptionsErrorEvent({
    required this.failure,
  }) : super();
}
