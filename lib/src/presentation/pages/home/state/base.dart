part of home_page;

enum PressType {
  down,
  up,
}

abstract class _IHomeState extends Equatable {
  final StreamController<PressType> logoPress;
  final NavbarPage currentPage;
  final Stream<PressType> logoPressBroadcast;
  final bool darkMode;

  _IHomeState copyWithDarkMode(bool darkMode);

  _IHomeState({
    required this.logoPress,
    required this.currentPage,
    required this.logoPressBroadcast,
    required this.darkMode,
  }) : super();

  @override
  List<Object> get props =>
      [currentPage, logoPress, logoPressBroadcast, darkMode];
}
