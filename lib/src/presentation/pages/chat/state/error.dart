part of chat_page;

class _ErrorState extends _IChatState {
  final Failure failure;

  const _ErrorState({required this.failure}) : super();

  @override
  List<Object> get props => [failure];
}
