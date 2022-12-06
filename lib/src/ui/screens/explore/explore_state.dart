import 'dart:async';

import '../../../entities/entities.dart';
import '../state.dart';

class ExploreState extends ScreenState {
  int _countdown = 3;
  bool _holding = false;
  Timer? counter;

  int get countdown => _countdown;
  bool get holding => _holding;

  List<ExploreUserEntity> _exploreUsers = [
    ExploreUserEntity(
      id: "1",
      cognitoId: "1",
      firstName: "Erin-Michelle",
      lastName: "Jeankowski",
    ),
    ExploreUserEntity(
      id: "2",
      cognitoId: "2",
      firstName: "Koustav",
      lastName: "M.",
    ),
    ExploreUserEntity(
      id: "3",
      cognitoId: "3",
      firstName: "Priscilla",
      lastName: "H.",
    ),
    ExploreUserEntity(
      id: "4",
      cognitoId: "4",
      firstName: "John",
      lastName: "S.",
    )
  ];

  int currentUserIndex = 0;

  List<ExploreUserEntity> get exploreUsers => _exploreUsers;

  void removeExploreUser(int index) {
    _exploreUsers.removeAt(index);
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
