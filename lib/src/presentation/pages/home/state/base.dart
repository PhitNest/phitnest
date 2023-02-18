part of home_page;

enum PressType {
  down,
  up,
}

abstract class _IHomeState extends Equatable {
  final StreamController<PressType> logoPress;
  final NavbarPage currentPage;

  const _IHomeState({
    required this.logoPress,
    required this.currentPage,
  }) : super();

  @override
  List<Object> get props => [
        currentPage,
        logoPress,
      ];
}
