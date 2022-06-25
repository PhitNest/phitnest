import 'package:flutter/material.dart';

import '../../../../services/services.dart';
import '../../screen_model.dart';
import '../../screen_view.dart';
import '../redirected_provider.dart';

/// This is a provider that will redirect if the user is authenticated.
abstract class PreAuthenticationProvider<T extends ScreenModel,
    K extends ScreenView> extends RedirectedProvider<T, K> {
  const PreAuthenticationProvider({Key? key}) : super(key: key);

  /// Redirected authenticated users to the home route.
  @override
  String get redirectRoute => '/home';

  /// Redirect the user to the home route if they are authenticated.
  @override
  Future<bool> get shouldRedirect =>
      authService.isAuthenticatedOrHasAuthCache();
}
