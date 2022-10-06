import 'package:flutter/material.dart';

import '../provider.dart';
import 'home_state.dart';
import 'home_view.dart';

class HomeProvider extends ScreenProvider<HomeState, HomeView> {
  const HomeProvider() : super();

  @override
  HomeView build(BuildContext context, HomeState state) => HomeView();

  @override
  HomeState buildState() => HomeState();
}
