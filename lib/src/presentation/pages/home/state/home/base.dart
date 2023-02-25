part of home_page;

abstract class IHomeState {
  final NavbarPage currentPage;

  const IHomeState({
    required this.currentPage,
  }) : super();
}
