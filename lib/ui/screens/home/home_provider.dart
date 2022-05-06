import 'package:flutter/material.dart';

import '../providers.dart';
import 'home_model.dart';
import 'home_view.dart';

class HomeProvider extends AuthenticatedProvider<HomeModel, HomeView> {
  const HomeProvider({Key? key}) : super(key: key);

  @override
  init(BuildContext context, HomeModel model) async {
    if (await super.init(context, model)) {
      await model.updateLocation();
      return true;
    }

    return false;
  }

  @override
  HomeView buildView(BuildContext context, HomeModel model) => const HomeView();
}
