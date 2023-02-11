part of home_page;

class _SetPageEvent extends _HomeEvent {
  final NavbarPage page;

  const _SetPageEvent(this.page) : super();

  @override
  List<Object> get props => [page];
}
