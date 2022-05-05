import 'package:flutter/material.dart';

import '../base_view.dart';
import '../base_model.dart';

/// This view will redirect a user to a given route on initialization if a given
/// condition is met.
abstract class RedirectedView<T extends BaseModel> extends BaseView<T> {
  const RedirectedView({Key? key}) : super(key: key);

  /// This is the route to redirect to.
  String get redirectRoute;

  /// This is the condition to control whether or not to redirect.
  Future<bool> get shouldRedirect;

  @override
  init(BuildContext context, T model) async {
    if (await shouldRedirect)
      Navigator.pushNamedAndRemoveUntil(context, redirectRoute, (_) => false);
  }
}
