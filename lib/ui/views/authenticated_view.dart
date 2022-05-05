import 'package:flutter/material.dart';

import '../../services/authentication_service.dart';
import '../../locator.dart';
import 'base_view.dart';
import 'base_model.dart';

abstract class AuthenticatedView<T extends BaseModel> extends BaseView<T> {
  static const String baseRoot = '/';

  @override
  init(BuildContext context, T model) async {
    if (!await locator<AuthenticationService>().isAuthenticated()) {
      Navigator.pushNamed(context, baseRoot);
    }
  }
}
