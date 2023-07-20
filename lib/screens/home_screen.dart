import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../widgets/widgets.dart';
import 'login_screen.dart';

typedef LogoutBloc = LoaderBloc<void, void>;
typedef LogoutConsumer = LoaderConsumer<void, void>;

extension on BuildContext {
  LogoutBloc get logoutBloc => loader();
}

final class HomeScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const HomeScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) {
    returnToLogin(BuildContext context) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
            builder: (context) => LoginScreen(
              apiInfo: apiInfo,
            ),
          ),
          (_) => false,
        );
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InviteForm(onSessionLost: returnToLogin),
              GymEntryForm(onSessionLost: returnToLogin),
            ],
          ),
          BlocProvider(
            create: (context) => LogoutBloc(
              load: (_) async {
                final session = await context.sessionLoader.session;
                if (session != null) {
                  await logout(session: session);
                }
              },
            ),
            child: LogoutConsumer(
              listener: (context, logoutState) {
                switch (logoutState) {
                  case LoaderLoadedState():
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => LoginScreen(
                          apiInfo: apiInfo,
                        ),
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
                    onPressed: () =>
                        context.logoutBloc.add(const LoaderLoadEvent(null)),
                    child: const Text('Logout'),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
