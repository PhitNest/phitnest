import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../../use_cases/use_cases.dart';
import '../login/login.dart';
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

void _handleHomeStateChanged(BuildContext context, HomeState homeState) {}

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

void _handleState<T>(
  BuildContext context, {
  required void Function(BuildContext context, T data) onSuccess,
  required void Function(BuildContext context, Failure failure) onFailure,
  required void Function(BuildContext context, String message) authLost,
  required LoaderState<AuthResOrLost<HttpResponse<T>>> loaderState,
}) =>
    switch (loaderState) {
      LoaderLoadedState(data: final response) => switch (response) {
          AuthRes(data: final response) => switch (response) {
              HttpResponseSuccess(data: final response) =>
                onSuccess(context, response),
              HttpResponseFailure(failure: final failure) =>
                onFailure(context, failure),
            },
          AuthLost(message: final message) => authLost(context, message),
        },
      _ => null,
    };

void _handleGetUserStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<HttpResponse<GetUserResponse>>> loaderState,
) =>
    _handleState(
      context,
      loaderState: loaderState,
      onSuccess: (context, data) => _handleState(
        context,
        onSuccess: (context, exploreData) =>
            context.homeBloc.add(HomeLoadedEvent(exploreData)),
        onFailure: (context, failure) {},
        authLost: (context, message) {},
        loaderState: context.exploreBloc.state,
      ),
      onFailure: (context, data) => context.userBloc
          .add(LoaderLoadEvent(AuthReq(null, context.sessionLoader))),
      authLost: _goToLogin,
    );

void _handleExploreStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<HttpResponse<List<UserExplore>>>> loaderState,
) =>
    _handleState(
      context,
      loaderState: loaderState,
      onSuccess: (context, data) => _handleState(
        context,
        onSuccess: (context, userData) =>
            context.homeBloc.add(HomeLoadedEvent(data)),
        onFailure: (context, failure) {},
        authLost: (context, message) {},
        loaderState: context.userBloc.state,
      ),
      onFailure: (context, failure) => context.exploreBloc
          .add(LoaderLoadEvent(AuthReq(null, context.sessionLoader))),
      authLost: _goToLogin,
    );

class HomePage extends StatelessWidget {
  const HomePage({super.key}) : super();

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
            BlocProvider(
              create: (_) => HomeBloc(),
            ),
            BlocProvider(
              create: (_) => NavBarBloc(),
            ),
          ],
          child: LogoutConsumer(
            listener: _handleLogoutStateChanged,
            builder: (context, logoutState) => UserConsumer(
              listener: _handleGetUserStateChanged,
              builder: (context, userState) => ExploreConsumer(
                  listener: _handleExploreStateChanged,
                  builder: (context, exploreState) =>
                      BlocConsumer<HomeBloc, HomeState>(
                        listener: _handleHomeStateChanged,
                        builder: (context, homeState) => NavBar(
                          builder: (context, navBarState) =>
                              switch (navBarState.page) {
                            NavBarPage.explore => ExploreScreen(
                                pageController: context.homeBloc.pageController,
                                homeState: homeState,
                                navBarState: navBarState,
                              ),
                            NavBarPage.news => Container(),
                            NavBarPage.chat => Container(),
                            NavBarPage.options => Container(),
                          },
                        ),
                      )),
            ),
          ),
        ),
      );
}
