import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phitnest_core/core.dart';

import 'common/util.dart';
import 'screens/change_password/ui.dart';
import 'screens/home/ui.dart';
import 'screens/login/ui.dart';

const kLoader = Scaffold(body: Center(child: CircularProgressIndicator()));

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'base',
      builder: (context, state) {
        switch (context.cognitoBloc.state) {
          case CognitoLoadingPreviousSessionState():
          case CognitoLoggedInState():
            Future.delayed(Duration.zero, () => context.goNamed('home'));
          case CognitoLoginFailureState(failure: final failure):
            switch (failure) {
              case LoginChangePasswordRequired():
                Future.delayed(
                    Duration.zero, () => context.goNamed('changePassword'));
              default:
                Future.delayed(Duration.zero, () => context.goNamed('login'));
            }
          default:
            Future.delayed(Duration.zero, () => context.goNamed('login'));
        }
        return kLoader;
      },
      routes: [
        GoRoute(
          path: 'login',
          name: 'login',
          builder: (context, state) {
            switch (context.cognitoBloc.state) {
              case CognitoLoadingPreviousSessionState():
                Future.delayed(Duration.zero, () => context.goNamed('base'));
              case CognitoLoggedInState():
                Future.delayed(Duration.zero, () => context.goNamed('home'));
              case CognitoLoginFailureState(failure: final failure):
                switch (failure) {
                  case LoginChangePasswordRequired():
                    Future.delayed(
                        Duration.zero, () => context.goNamed('changePassword'));
                  default:
                    return const LoginScreen();
                }
              default:
                return const LoginScreen();
            }
            return kLoader;
          },
        ),
        GoRoute(
          path: 'home',
          name: 'home',
          builder: (context, state) {
            switch (context.cognitoBloc.state) {
              case CognitoLoadingPreviousSessionState():
                Future.delayed(Duration.zero, () => context.goNamed('base'));
              case CognitoLoggedInState(session: final session):
                return HomeScreen(
                  authorization: session.session.idToken.jwtToken!,
                );
              case CognitoLoginFailureState(failure: final failure):
                switch (failure) {
                  case LoginChangePasswordRequired():
                    Future.delayed(
                        Duration.zero, () => context.goNamed('changePassword'));
                  default:
                    Future.delayed(
                        Duration.zero, () => context.goNamed('login'));
                }
              default:
                Future.delayed(Duration.zero, () => context.goNamed('login'));
            }
            return kLoader;
          },
        ),
        GoRoute(
          path: 'changePassword',
          name: 'changePassword',
          builder: (context, state) {
            switch (context.cognitoBloc.state) {
              case CognitoLoggedInState():
                Future.delayed(Duration.zero, () => context.goNamed('home'));
              case CognitoLoginFailureState(failure: final failure):
                switch (failure) {
                  case LoginChangePasswordRequired():
                    return ChangePasswordScreen(email: failure.user.username!);
                  default:
                    Future.delayed(
                        Duration.zero, () => context.goNamed('login'));
                }
              default:
                Future.delayed(Duration.zero, () => context.goNamed('login'));
            }
            return kLoader;
          },
        ),
      ],
    ),
  ],
);
