part of home_page;

enum PressType {
  down,
  up,
}

abstract class _IHomeState extends Equatable {
  final StreamController<PressType> logoPress;
  final NavbarPage currentPage;
  final Stream<PressType> logoPressBroadcast;
  final StreamSubscription<PressType> logoPressListener;
  final bool freezeLogoAnimation;
  final bool darkMode;

  _IHomeState copyWithDarkMode(bool darkMode);

  _IHomeState copyWithFreezeAnimation(bool freezeAnimation);

  _IHomeState({
    required this.logoPress,
    required this.currentPage,
    required this.logoPressBroadcast,
    required this.darkMode,
    required this.logoPressListener,
    required this.freezeLogoAnimation,
  }) : super();

  @override
  List<Object> get props => [
        currentPage,
        logoPress,
        logoPressBroadcast,
        darkMode,
        freezeLogoAnimation,
        logoPressListener
      ];
}
