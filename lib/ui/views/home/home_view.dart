import 'package:flutter/material.dart';

import '../redirected/authenticated_view.dart';
import 'model/home_model.dart';

/// This is the view shown when users have been authenticated.
class HomeView extends AuthenticatedView<HomeModel> {
  @override
  Widget build(BuildContext context, HomeModel model) {
    return Scaffold();
  }
}
