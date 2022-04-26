import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../screen_utils.dart';

class HomeFunctions {
  final BuildContext context;
  late final BackEndModel _backEnd;
  late final UserModel _user;

  HomeFunctions(this.context) {
    _backEnd = BackEndModel.getBackEnd(context);
    _user = _backEnd.currentUser!;
  }

  void setUserActive() async {
    _user.active = true;
    _backEnd.updateCurrentUser(user: _user);
  }

  void checkSubscription() async {
    if (_user.isVip) {
      await DialogUtils.showProgress(context, 'Loading...', false);
      await _backEnd.updateSubscription();
      await DialogUtils.hideProgress();
    }
  }
}
