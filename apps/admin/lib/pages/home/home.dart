import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../login/login.dart';
import 'widgets/widgets.dart';

void _returnToLogin(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const LoginPage(),
      ),
      (_) => false,
    );

void _handleLogoutStateChanged(
  BuildContext context,
  LoaderState<void> logoutState,
) {
  switch (logoutState) {
    case LoaderLoadedState():
      _returnToLogin(context);
    default:
  }
}

final class HomePage extends StatelessWidget {
  const HomePage({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InviteForm(onSessionLost: _returnToLogin),
                GymEntryForm(onSessionLost: _returnToLogin),
              ],
            ),
            BlocProvider(
              create: logoutBloc,
              child: LogoutConsumer(
                listener: _handleLogoutStateChanged,
                builder: (context, logoutState) => switch (logoutState) {
                  LoaderLoadingState() ||
                  LoaderLoadedState() =>
                    const CircularProgressIndicator(),
                  _ => TextButton(
                      onPressed: () => context.logoutBloc.add(LoaderLoadEvent(
                          AuthReq(null, context.sessionLoader))),
                      child: const Text('Logout'),
                    ),
                },
              ),
            ),
          ],
        ),
      );
}
