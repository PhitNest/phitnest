import 'dart:async';

import '../state.dart';

class ExploreTutorialState extends ScreenState {
  int _countdown = 3;
  bool _holding = false;
  Timer? counter;

  int get countdown => _countdown;
  bool get holding => _holding;

  set countdown(int countdown) {
    _countdown = countdown;
    notifyListeners();
  }

  set holding(bool holding) {
    _holding = holding;
    notifyListeners();
  }

  @override
  dispose() {
    counter?.cancel();
    super.dispose();
  }
}
