import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/change_password/ui.dart';
import 'screens/login/ui.dart';

const kLoader = Scaffold(body: CircularProgressIndicator());

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const LoginScreen(),
      routes: [
        GoRoute(
          path: 'changePassword',
          name: 'changePassword',
          builder: (context, state) {
            final email = state.queryParameters['email'];
            if (email == null) {
              context.goNamed('home');
              return kLoader;
            } else {
              return ChangePasswordScreen(email: email);
            }
          },
        ),
      ],
    ),
  ],
);
