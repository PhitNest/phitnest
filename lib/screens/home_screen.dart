import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../widgets/widgets.dart';
import 'login_screen.dart';

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
            create: (context) => LoaderBloc<void, void>(
              load: (_) async {
                final session = await context.sessionLoader.session;
                if (session != null) {
                  await logout(session: session);
                }
              },
            ),
            child: LoaderConsumer<void, void>(
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
                LoaderLoadingState() => const CircularProgressIndicator(),
                _ => TextButton(
                    onPressed: () => context
                        .loader<void, void>()
                        .add(const LoaderLoadEvent(null)),
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
