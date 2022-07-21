import 'package:flutter/material.dart';

import '../../../../apis/apis.dart';
import '../../screen_model.dart';
import '../../screen_view.dart';
import '../redirector.dart';

/// This is a provider that will redirect if the user is not authenticated.
abstract class AuthenticatedProvider<T extends ScreenModel,
    K extends ScreenView> extends RedirectorProvider<T, K> {
  const AuthenticatedProvider({Key? key}) : super(key: key);

  /// Redirected unauthenticated users to the screen route.
  @override
  String get redirectRoute => '/';

  /// Redirect the user to the screen route if they are not authenticated.
  @override
  Future<bool> get shouldRedirect async =>
      !await AuthApi.instance.isAuthenticated();
}
