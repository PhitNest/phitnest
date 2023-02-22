part of home_page;

class _ChatLoadingErrorEvent extends _IChatEvent {
  final Failure failure;

  const _ChatLoadingErrorEvent(this.failure) : super();
}
