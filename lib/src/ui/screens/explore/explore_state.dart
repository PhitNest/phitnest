import 'dart:async';

import '../../../entities/entities.dart';
import '../state.dart';

class ExploreState extends ScreenState {
  int _countdown = 3;
  bool _holding = false;
  Timer? counter;

  int get countdown => _countdown;
  bool get holding => _holding;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? errorMessage) {
    _errorMessage = errorMessage;
    rebuildView();
  }

  List<ExploreUserEntity>? _exploreUsers;

  int currentUserIndex = 0;

  List<ExploreUserEntity>? get exploreUsers => _exploreUsers;

  set exploreUsers(List<ExploreUserEntity>? exploreUsers) {
    _exploreUsers = exploreUsers;
    rebuildView();
  }

  void removeExploreUser(int index) {
    _exploreUsers!.removeAt(index);
    rebuildView();
  }

  set countdown(int countdown) {
    _countdown = countdown;
    rebuildView();
  }

  set holding(bool holding) {
    _holding = holding;
    rebuildView();
  }

  @override
  dispose() {
    counter?.cancel();
    super.dispose();
  }
}
