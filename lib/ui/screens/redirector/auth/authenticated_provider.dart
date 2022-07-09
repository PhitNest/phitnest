// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:phitnest/ui/screens/redirector/auth/authenticated_model.dart';

import '../../../../apis/api.dart';
import '../../../../models/models.dart';
import '../../screen_view.dart';
import '../redirector_provider.dart';

/// This is a provider that will redirect if the user is not authenticated.
abstract class AuthenticatedProvider<T extends AuthenticatedModel,
    K extends ScreenView> extends RedirectorProvider<T, K> {
  const AuthenticatedProvider({Key? key}) : super(key: key);

  @override
  Future<bool> init(BuildContext context, T model) async {
    if (!await super.init(context, model)) {
      return false;
    }
    AuthenticatedUser? user = await api<SocialApi>().getSignedInUser();
    if (user == null) {
      return false;
    }
    model.currentUser = user;
    return true;
  }

  /// Redirected unauthenticated users to the screen route.
  @override
  String get redirectRoute => '/';

  /// Redirect the user to the screen route if they are not authenticated.
  @override
  Future<bool> get shouldRedirect async =>
      await api<AuthenticationApi>().getAuthenticatedUid() == null;
}
