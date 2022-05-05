import 'package:flutter/material.dart';

import '../../../services/authentication_service.dart';
import '../../../locator.dart';
import '../base_model.dart';
import 'redirected_view.dart';

/// This is a view that will redirect if the user is not authenticated.
abstract class AuthenticatedView<T extends BaseModel>
    extends RedirectedView<T> {
  const AuthenticatedView({Key? key}) : super(key: key);

  /// Redirected unauthenticated users to the base route.
  @override
  String get redirectRoute => '/';

  /// Redirect the user to the base route if they are not authenticated.
  @override
  Future<bool> get shouldRedirect async =>
      !await locator<AuthenticationService>().isAuthenticated();
}
