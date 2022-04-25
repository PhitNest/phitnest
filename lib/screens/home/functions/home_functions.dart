import 'package:flutter/material.dart';

import '../../../app.dart';

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
    await _backEnd.updateCurrentUser(_user);
  }

  void checkSubscription() async {
    if (_user.isVip) {
      await DialogUtils.showProgress(context, 'Loading...', false);
      await _backEnd.updateSubscription();
      await DialogUtils.hideProgress();
    }
  }
}
