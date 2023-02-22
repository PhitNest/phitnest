part of home_page;

abstract class _IHomeState extends Equatable {
  final NavbarPage currentPage;

  const _IHomeState({
    required this.currentPage,
  }) : super();

  @override
  List<Object> get props => [currentPage];
}
