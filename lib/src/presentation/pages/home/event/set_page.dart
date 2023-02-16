part of home_page;

class _SetPageEvent extends _IHomeEvent {
  final NavbarPage page;

  const _SetPageEvent(this.page) : super();

  @override
  List<Object> get props => [page];
}
