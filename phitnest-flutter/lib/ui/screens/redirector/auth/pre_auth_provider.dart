import 'package:flutter/material.dart';

import '../../../../apis/auth_api.dart';
import '../../screen_model.dart';
import '../../screen_view.dart';
import '../redirector_provider.dart';

/// This is a provider that will redirect if the user is authenticated.
abstract class PreAuthenticationProvider<T extends ScreenModel,
    K extends ScreenView> extends RedirectorProvider<T, K> {
  const PreAuthenticationProvider({Key? key}) : super(key: key);

  /// Redirected authenticated users to the home route.
  @override
  String get redirectRoute => '/home';

  /// Redirect the user to the home route if they are authenticated.
  @override
  Future<bool> get shouldRedirect => AuthApi.instance.isAuthenticated();
}
