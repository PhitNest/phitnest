import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../widgets/widgets.dart';
import 'login_screen.dart';

final class HomeScreen extends StatelessWidget {
  final Session session;

  const HomeScreen({
    super.key,
    required this.session,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InviteForm(
                  session: session,
                ),
                GymEntryForm(
                  session: session,
                ),
              ],
            ),
            BlocProvider(
              create: (_) => LoaderBloc<void, void>(
                load: (_) => logout(session: session),
              ),
              child: LoaderConsumer<void, void>(
                listener: (context, logoutState) {
                  switch (logoutState) {
                    case LoaderLoadedState():
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => LoginScreen(
                            apiInfo: session.apiInfo,
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
