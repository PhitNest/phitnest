import 'package:flutter/material.dart';

import '../views.dart';
import 'model/home_model.dart';

/// This is the view shown when users have been authenticated.
class HomeView extends AuthenticatedView<HomeModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  init(BuildContext context, HomeModel model) async {
    await super.init(context, model);

    if (!await shouldRedirect) {
      await model.updateLocation();
      model.loading = false;
    }
  }

  @override
  Widget build(BuildContext context, HomeModel model) {
    return Scaffold();
  }
}
