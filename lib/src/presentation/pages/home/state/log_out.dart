part of home_page;

class _LogOutState extends _IHomeState {
  _LogOutState({
    required super.currentPage,
    required super.logoPress,
    required super.logoPressBroadcast,
    required super.darkMode,
    required super.logoPressListener,
    required super.freezeLogoAnimation,
  }) : super();

  _IHomeState copyWithDarkMode(bool darkMode) => _LogOutState(
        currentPage: currentPage,
        logoPress: logoPress,
        logoPressBroadcast: logoPressBroadcast,
        darkMode: darkMode,
        logoPressListener: logoPressListener,
        freezeLogoAnimation: freezeLogoAnimation,
      );

  _IHomeState copyWithFreezeAnimation(bool freezeAnimation) => _LogOutState(
        currentPage: currentPage,
        logoPress: logoPress,
        logoPressBroadcast: logoPressBroadcast,
        darkMode: darkMode,
        logoPressListener: logoPressListener,
        freezeLogoAnimation: freezeAnimation,
      );
}
