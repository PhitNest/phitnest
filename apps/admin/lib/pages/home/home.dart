import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../repositories/gym.dart';
import '../login/login.dart';
import 'widgets/widgets.dart';

part 'bloc.dart';

void _returnToLogin(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const LoginPage(),
      ),
      (_) => false,
    );

void _handleLogoutStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<void>> logoutState,
) {
  switch (logoutState) {
    case LoaderLoadedState():
      _returnToLogin(context);
    default:
  }
}

void _handleGetGymStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<HttpResponse<void>>> getGymState,
) {
  switch (getGymState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case AuthLost():
          _returnToLogin(context);
        default:
      }
    default:
  }
}

final class HomePage extends StatelessWidget {
  const HomePage({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: MultiBlocProvider(
          providers: [
            const BlocProvider(create: logoutBloc),
            BlocProvider(
              create: (_) => GetGymBloc(
                load: (_, session) => getGym(session),
                loadOnStart: AuthReq(null, context.sessionLoader),
              ),
            ),
          ],
          child: LogoutConsumer(
            listener: _handleLogoutStateChanged,
            builder: (context, logoutState) => switch (logoutState) {
              LoaderLoadingState() ||
              LoaderLoadedState() =>
                const CircularProgressIndicator(),
              _ => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetGymConsumer(
                      listener: _handleGetGymStateChanged,
                      builder: (context, getGymState) => switch (getGymState) {
                        LoaderLoadingState() ||
                        LoaderInitialState() =>
                          const Loader(),
                        LoaderLoadedState(data: final response) => switch (
                              response) {
                            AuthRes(data: final response) => switch (response) {
                                HttpResponseSuccess() => const InviteForm(
                                    onSessionLost: _returnToLogin),
                                HttpResponseFailure() => const GymEntryForm(
                                    onSessionLost: _returnToLogin),
                              },
                            AuthLost() => const Loader(),
                          }
                      },
                    ),
                    TextButton(
                      onPressed: () => context.logoutBloc.add(LoaderLoadEvent(
                          AuthReq(null, context.sessionLoader))),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
            },
          ),
        ),
      );
}
