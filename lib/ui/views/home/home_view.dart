import 'package:flutter/material.dart';

import '../../../services/authentication_service.dart';
import '../../../locator.dart';
import '../redirected_view.dart';
import '../base_model.dart';
import 'model/home_model.dart';

/// This is the view shown when users have been authenticated.
class HomeView extends RedirectedView<HomeModel> {
  /// Redirected unauthenticated users to the base root.
  @override
  String get redirectRoute => '/';

  /// Redirect the user to the base route if they are not authenticated.
  @override
  Future<bool> get shouldRedirect async =>
      !await locator<AuthenticationService>().isAuthenticated();

  /// TODO
  @override
  Widget build(BuildContext context, BaseModel model) {
    return Scaffold();
  }
}
