part of chat_page;

class _ErrorState extends _IChatState {
  final StyledErrorBanner errorBanner;

  const _ErrorState({
    required this.errorBanner,
  }) : super();

  @override
  List<Object> get props => [errorBanner];
}
