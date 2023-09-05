import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../../use_cases/use_cases.dart';
import '../pages.dart';
import 'widgets/widgets.dart';

part 'bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key}) : super();

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();

  _HomePageState() : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => UserBloc(
                  load: (_, session) => user(session),
                  loadOnStart: AuthReq(null, context.sessionLoader)),
            ),
            BlocProvider(
              create: (_) => SendFriendRequestBloc(load: sendFriendRequest),
            ),
            const BlocProvider(create: logoutBloc),
            BlocProvider(create: (_) => NavBarBloc()),
          ],
          child: NavBar(
            pageController: pageController,
            builder: (context, navBarState) => LogoutConsumer(
              listener: _handleLogoutStateChanged,
              builder: (context, logoutState) => SendFriendRequestConsumer(
                listener: _handleSendFriendRequestStateChanged,
                builder: (context, sendFriendRequestState) => UserConsumer(
                  listener: (context, userState) => _handleGetUserStateChanged(
                      context, userState, navBarState),
                  builder: (context, userState) => switch (logoutState) {
                    LoaderInitialState() => switch (userState) {
                        LoaderLoadedState(data: final response) => switch (
                              response) {
                            AuthRes(data: final response) => switch (response) {
                                HttpResponseSuccess(
                                  data: final getUserResponse
                                ) =>
                                  switch (getUserResponse) {
                                    GetUserSuccess() => switch (
                                          navBarState.page) {
                                        NavBarPage.explore => ExploreScreen(
                                            pageController: pageController,
                                            users: getUserResponse
                                                .exploreWithPictures,
                                            navBarState: navBarState,
                                          ),
                                        NavBarPage.news => Container(),
                                        NavBarPage.chat => Container(),
                                        NavBarPage.options => OptionsScreen(
                                            user: getUserResponse.user,
                                            profilePicture:
                                                getUserResponse.profilePicture,
                                            gym: getUserResponse.gym,
                                          ),
                                      },
                                    _ => const Loader(),
                                  },
                                _ => const Loader(),
                              },
                            _ => const Loader(),
                          },
                        _ => const Loader(),
                      },
                    _ => const Loader(),
                  },
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
