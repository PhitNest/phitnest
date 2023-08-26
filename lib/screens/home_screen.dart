import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../widgets/widgets.dart';
import 'login_screen.dart';

typedef LogoutBloc = AuthLoaderBloc<void, void>;
typedef LogoutConsumer = AuthLoaderConsumer<void, void>;

extension on BuildContext {
  LogoutBloc get logoutBloc => authLoader();
}

final class HomeScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const HomeScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  void returnToLogin(BuildContext context) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (context) => LoginScreen(
            apiInfo: apiInfo,
          ),
        ),
        (_) => false,
      );

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
              create: (context) => LogoutBloc(
                apiInfo: apiInfo,
                load: (_, session) => logout(session: session),
              ),
              child: LogoutConsumer(
                listener: (context, logoutState) {
                  switch (logoutState) {
                    case LoaderLoadedState():
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => LoginScreen(apiInfo: apiInfo),
                        ),
                        (_) => false,
                      );
                    default:
                  }
                },
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
