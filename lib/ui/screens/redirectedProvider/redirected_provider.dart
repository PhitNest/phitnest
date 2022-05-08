import 'package:flutter/material.dart';

import '../providers.dart';
import '../models.dart';
import '../views.dart';

/// This view will redirect a user to a given route on initialization if a given
/// condition is met.
abstract class RedirectedProvider<T extends BaseModel, K extends BaseView>
    extends BaseProvider<T, K> {
  RedirectedProvider({Key? key}) : super(key: key);

  /// This is the route to redirect to.
  String get redirectRoute;

  /// This is the condition to control whether or not to redirect.
  Future<bool> get shouldRedirect;

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
