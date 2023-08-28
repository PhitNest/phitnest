import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../login/login.dart';
import 'widgets/widgets.dart';

final class HomePage extends StatelessWidget {
  final ApiInfo apiInfo;

  const HomePage({
    super.key,
    required this.apiInfo,
  }) : super();

  void returnToLogin(BuildContext context) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (context) => LoginPage(apiInfo: apiInfo),
        ),
        (_) => false,
      );

  void handleLogoutStateChanged(
      BuildContext context, LoaderState<void> logoutState) {
    switch (logoutState) {
      case LoaderLoadedState():
        returnToLogin(context);
      default:
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InviteForm(apiInfo: apiInfo, onSessionLost: returnToLogin),
                GymEntryForm(apiInfo: apiInfo, onSessionLost: returnToLogin),
              ],
            ),
            BlocProvider(
              create: (context) => createLogoutBloc(apiInfo, context),
              child: LogoutConsumer(
                listener: handleLogoutStateChanged,
                builder: (context, logoutState) => switch (logoutState) {
                  LoaderLoadingState() ||
                  LoaderLoadedState() =>
                    const CircularProgressIndicator(),
                  _ => TextButton(
                      onPressed: () => context.logoutBloc.add(LoaderLoadEvent(
                          (data: null, sessionLoader: context.sessionLoader))),
                      child: const Text('Logout'),
                    ),
                },
              ),
            ),
          ],
        ),
      );
}
