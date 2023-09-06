import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../../use_cases/use_cases.dart';
import '../pages.dart';
import 'widgets/chat/chat.dart';
import 'widgets/widgets.dart';

part 'bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key}) : super();

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

Widget _buildHome(
  LoaderState<AuthResOrLost<HttpResponse<bool>>> deleteUserState,
  LoaderState<AuthResOrLost<void>> logoutState,
  LoaderState<AuthResOrLost<HttpResponse<GetUserResponse>>> userState,
  Widget Function(GetUserSuccess userResponse) builder,
) {
  Widget homeBuilder() => switch (logoutState) {
        LoaderInitialState() => switch (userState) {
            LoaderLoadedState(data: final response) => switch (response) {
                AuthRes(data: final response) => switch (response) {
                    HttpResponseSuccess(data: final getUserResponse) => switch (
                          getUserResponse) {
                        GetUserSuccess() => builder(getUserResponse),
                        _ => const Loader(),
                      },
                    _ => const Loader(),
                  },
                _ => const Loader(),
              },
            _ => const Loader(),
          },
        _ => const Loader(),
      };

  return switch (deleteUserState) {
    LoaderInitialState() => homeBuilder(),
    LoaderLoadedState(data: final response) => switch (response) {
        AuthRes(data: final response) => switch (response) {
            HttpResponseSuccess(data: final deleted) =>
              deleted ? const Loader() : homeBuilder(),
            HttpResponseFailure() => homeBuilder(),
          },
        _ => const Loader(),
      },
    _ => const Loader(),
  };
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
              create: (_) => SendFriendRequestBloc(
                  load: (user, session) async =>
                      await sendFriendRequest(user.user.id, session)),
            ),
            const BlocProvider(create: logoutBloc),
            BlocProvider(
              create: (_) => DeleteUserBloc(
                load: (_, session) => deleteUserAccount(session),
              ),
            ),
            BlocProvider(create: (_) => NavBarBloc()),
          ],
          child: DeleteUserConsumer(
            listener: _handleDeleteUserStateChanged,
            builder: (context, deleteUserState) => LogoutConsumer(
              listener: _handleLogoutStateChanged,
              builder: (context, logoutState) => NavBarConsumer(
                pageController: pageController,
                builder: (context, navBarState) => UserConsumer(
                  listener: (context, userState) => _handleGetUserStateChanged(
                      context, userState, navBarState),
                  builder: (context, userState) => _buildHome(
                    deleteUserState,
                    logoutState,
                    userState,
                    (getUserResponse) => SendFriendRequestConsumer(
                      listener: (context, sendFriendRequestState) =>
                          _handleSendFriendRequestStateChanged(
                        context,
                        sendFriendRequestState,
                        getUserResponse,
                      ),
                      builder: (context, sendFriendRequestState) =>
                          switch (navBarState) {
                        NavBarReversedState() =>
                          const Center(child: Text('You have matched!')),
                        _ => switch (navBarState.page) {
                            NavBarPage.explore => ExplorePage(
                                pageController: pageController,
                                users: getUserResponse.exploreUsers,
                                navBarState: navBarState,
                              ),
                            NavBarPage.news => Container(),
                            NavBarPage.chat => ChatPage(
                                userId: getUserResponse.user.id,
                                friends: getUserResponse.friendships,
                                sentFriendRequests:
                                    getUserResponse.sentFriendRequests,
                                receivedFriendRequests:
                                    getUserResponse.receivedFriendRequests,
                              ),
                            NavBarPage.options => OptionsPage(
                                user: getUserResponse.user,
                                profilePicture: getUserResponse.profilePicture,
                                gym: getUserResponse.gym,
                              ),
                          },
                      },
                    ),
                  ),
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
