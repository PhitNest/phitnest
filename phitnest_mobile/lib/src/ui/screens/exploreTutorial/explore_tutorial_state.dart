import '../state.dart';

class ExploreTutorialState extends ScreenState {
  int _screenIndex = 0;
  int _navIndex = 1;

  int get screenIndex => _screenIndex;
  int get navIndex => _navIndex;

  set setScreenIndex(int index) {
    _screenIndex = index;
    rebuildView();
  }
}
