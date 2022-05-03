import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class AuthenticationService extends ChangeNotifier {
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  set userModel(UserModel? userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  static AuthenticationService instance(BuildContext context) {
    return Provider.of<AuthenticationService>(context, listen: false);
  }
}
