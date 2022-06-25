import 'package:flutter/material.dart';

import '../base_model.dart';
import '../base_view.dart';
import '../providers.dart';

/// This view will redirect a user to a given route on initialization if a given
/// condition is met.
abstract class RedirectedProvider<T extends BaseModel, K extends BaseView>
    extends BaseProvider<T, K> {
  const RedirectedProvider({Key? key}) : super(key: key);

  /// This is the route to redirect to.
  String get redirectRoute;

  /// This is the condition to control whether or not to redirect.
  Future<bool> get shouldRedirect;

  /// If this returns true, the loading widget is dropped. If it returns false,
  /// the loading widget stays until we navigate away from the screen.
  /// In this case, the loading screen is dropped if we aren't redirecting. It
  /// stays up until we navigate away otherwise.
  @override
  init(BuildContext context, T model) async {
    if (!await super.init(context, model)) return false;

    if (await shouldRedirect) {
      Navigator.pushNamedAndRemoveUntil(context, redirectRoute, (_) => false);
      return false;
    }
    return true;
  }
}
