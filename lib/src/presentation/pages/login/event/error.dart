part of login_page;

class _ErrorEvent extends _LoginEvent {
  final Failure failure;

  const _ErrorEvent(
    this.failure,
  ) : super();

  @override
  List<Object> get props => [failure];
}
