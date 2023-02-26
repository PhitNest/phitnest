part of home_page;

class _HomeSocketInitializeSuccessEvent extends _IHomeEvent {
  final Stream<void> stream;

  const _HomeSocketInitializeSuccessEvent(this.stream) : super();
}
