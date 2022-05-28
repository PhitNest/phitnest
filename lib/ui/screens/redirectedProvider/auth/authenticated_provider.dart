import 'package:flutter/material.dart';

import '../../models.dart';
import '../../views.dart';
import '../redirected_provider.dart';

/// This is a provider that will redirect if the user is not authenticated.
abstract class AuthenticatedProvider<T extends BaseModel, K extends BaseView>
    extends RedirectedProvider<T, K> {
  const AuthenticatedProvider({required Key key}) : super(key: key);

  /// Redirected unauthenticated users to the base route.
  @override
  String get redirectRoute => '/';

  /// Redirect the user to the base route if they are not authenticated.
  @override
  Future<bool> get shouldRedirect async => !await authService.isAuthenticated();
}
