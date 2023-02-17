part of chat_page;

class _ErrorState extends _IChatState {
  final Failure failure;
  final Completer<void> dismiss;

  const _ErrorState({
    required this.failure,
    required this.dismiss,
  }) : super();

  @override
  List<Object> get props => [failure, dismiss];
}
