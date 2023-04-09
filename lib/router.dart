import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/login/login.dart';

class AppRouter {
  GoRouter _router() {
    return GoRouter(
      routes: [
        GoRoute(
          path: AppRouterName.login,
          pageBuilder: (context, state) => const MaterialPage(
            child: LoginScreen(),
          ),
        ),
      ],
    );
  }

  GoRouter get router => _router();
}

class AppRouterName {
  static const String login = '/';
}

AppRouter appRouter = AppRouter();
