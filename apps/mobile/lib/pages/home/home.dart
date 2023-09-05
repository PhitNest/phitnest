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

void _goToLogin(BuildContext context, String? error) {
  if (error != null) {
    StyledBanner.show(message: error, error: true);
  }
  Navigator.pushAndRemoveUntil(
    context,
    CupertinoPageRoute<void>(
      builder: (context) => const LoginPage(),
    ),
    (_) => false,
  );
}

void _handleLogoutStateChanged(
  BuildContext context,
  LoaderState<void> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState():
      _goToLogin(context, null);
    default:
  }
}

void _handleGetUserStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<HttpResponse<GetUserResponse>>> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case AuthRes(data: final response):
          switch (response) {
            case HttpResponseSuccess(data: final response):
              switch (response) {
                case FailedToLoadProfilePicture():
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute<void>(
                      builder: (_) => const PhotoInstructionsPage(),
                    ),
                    (_) => false,
                  );
                default:
              }
            default:
          }
        case AuthLost(message: final message):
          _goToLogin(context, message);
      }
    default:
  }
}

void _handleExploreStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<HttpResponse<List<UserExploreWithPicture>>>>
      loaderState,
  NavBarState navBarState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case AuthRes(data: final response):
          switch (response) {
            case HttpResponseSuccess(data: final users):
              switch (navBarState) {
                case NavBarLoadingState(page: final page):
                  if (page == NavBarPage.explore && users.isNotEmpty) {
                    context.navBarBloc.add(const NavBarAnimateEvent());
                  } else {
                    context.navBarBloc.add(const NavBarSetLoadingEvent(null));
                  }
                default:
              }
            case HttpResponseFailure():
              context.exploreBloc
                  .add(LoaderLoadEvent(AuthReq(null, context.sessionLoader)));
          }
        case AuthLost(message: final message):
          _goToLogin(context, message);
      }
    default:
  }
}

void _handleSendFriendRequestStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<HttpResponse<FriendshipResponse>>> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case AuthRes(data: final data):
          switch (data) {
            case HttpResponseSuccess(data: final data):
              switch (data) {
                case FriendRequest():
                  StyledBanner.show(
                    message: 'Friend request sent',
                    error: false,
                  );
                  context.navBarBloc.add(const NavBarSetLoadingEvent(null));
                case FriendshipWithoutMessage():
                  StyledBanner.show(
                    message: 'Friend request accepted',
                    error: false,
                  );
                  context.navBarBloc.add(const NavBarReverseEvent());
              }
            case HttpResponseFailure(failure: final failure):
              StyledBanner.show(
                message: failure.message,
                error: true,
              );
              context.navBarBloc.add(const NavBarSetLoadingEvent(null));
            default:
          }
        case AuthLost():
          _goToLogin(context, null);
        default:
      }
    default:
  }
}

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
              create: (context) => ExploreBloc(
                  load: (_, session) => exploreUsers(session),
                  loadOnStart: AuthReq(null, context.sessionLoader)),
            ),
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
              builder: (context, logoutState) => UserConsumer(
                listener: _handleGetUserStateChanged,
                builder: (context, userState) => ExploreConsumer(
                  listener: (context, exploreState) =>
                      _handleExploreStateChanged(
                          context, exploreState, navBarState),
                  builder: (context, exploreState) => SendFriendRequestConsumer(
                    listener: _handleSendFriendRequestStateChanged,
                    builder: (context, sendFriendRequestState) =>
                        switch (logoutState) {
                      LoaderInitialState() => switch (userState) {
                          LoaderLoadedState(data: final response) => switch (
                                response) {
                              AuthRes(data: final response) => switch (
                                    response) {
                                  HttpResponseSuccess(
                                    data: final getUserResponse
                                  ) =>
                                    switch (getUserResponse) {
                                      GetUserSuccess() => switch (
                                            navBarState.page) {
                                          NavBarPage.explore => ExploreScreen(
                                              pageController: pageController,
                                              navBarState: navBarState,
                                            ),
                                          NavBarPage.news => Container(),
                                          NavBarPage.chat => Container(),
                                          NavBarPage.options => OptionsScreen(
                                              getUserResponse: getUserResponse,
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
        ),
      );
}
