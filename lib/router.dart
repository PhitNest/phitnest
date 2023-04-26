import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'screens/login/login.dart';

/// This is the main router provider for the app.
final Provider<AppRouter> appRouterProvider = Provider<AppRouter>(
  (ref) => AppRouter(),
);

/// [AppRouter] holds the all the routes config
class AppRouter {
  RouteMap get loggedOutRoute => _loggedOutRoute;

  final _loggedOutRoute = RouteMap(routes: {
    AppRouterPath.login: (context) => const MaterialPage(child: LoginScreen()),
  });
}

/// [AppRouterPath] holds the path of all the routes
abstract class AppRouterPath {
  static const String login = '/';
}
