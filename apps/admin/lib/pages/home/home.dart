import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../../repositories/gym.dart';
import '../login/login.dart';

part 'bloc.dart';

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
              _ => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GetGymConsumer(
                        listener: _handleGetGymStateChanged,
                        builder: (context, getGymState) =>
                            switch (getGymState) {
                          LoaderLoadingState() ||
                          LoaderInitialState() =>
                            const Loader(),
                          LoaderLoadedState() =>
                            const Text('Invite system temporarily disabled'),
                        },
                      ),
                      32.verticalSpace,
                      TextButton(
                        onPressed: () => context.logoutBloc.add(LoaderLoadEvent(
                            AuthReq(null, context.sessionLoader))),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
            },
          ),
        ),
      );
}
