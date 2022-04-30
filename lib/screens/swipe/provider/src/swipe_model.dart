import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../models/models.dart';
import '../../../../widgets/widgets.dart';

class SwipeModel extends ChangeNotifier {
  late StreamController<List<UserModel>> tinderCardsStreamController;
  late Stream<List<UserModel>> tinderUsers;
  List<UserModel> swipedUsers = [];
  List<UserModel> users = [];
  CardController controller = CardController();

  @override
  void dispose() {
    tinderCardsStreamController.close();
    super.dispose();
  }
}
