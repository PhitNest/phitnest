part of chat_page;

class _ErrorEvent extends _ChatEvent {
  final Failure failure;

  const _ErrorEvent({required this.failure}) : super();

  @override
  List<Object> get props => [failure];
}
