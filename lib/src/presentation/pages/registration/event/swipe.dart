part of registration_page;

class _SwipeEvent extends _RegistrationEvent {
  final int pageIndex;

  const _SwipeEvent(this.pageIndex) : super();

  @override
  List<Object> get props => [pageIndex];
}
