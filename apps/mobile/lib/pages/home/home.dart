import 'package:async/async.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../../use_cases/use_cases.dart';
import '../login/login.dart';
import '../profile_photo/profile_photo.dart';
import 'widgets/widgets.dart';

part 'bloc/explore_bloc.dart';
part 'bloc/home_bloc.dart';
part 'bloc/user_bloc.dart';
part 'bloc/send_friend_request.dart';

class HomePage extends StatelessWidget {
  void goToLogin(BuildContext context, String? error) {
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

  void handleHomeStateChanged(BuildContext context, HomeState homeState) {
    switch (homeState) {
      case HomeSendingFriendRequestState(user: final user):
        context.sendFriendRequestBloc.add(
          LoaderLoadEvent(AuthReq(user.user.id, context.sessionLoader)),
        );
      default:
    }
  }

  void handleLogoutStateChanged(
    BuildContext context,
    LoaderState<void> loaderState,
  ) {
    switch (loaderState) {
      case LoaderLoadedState():
        goToLogin(context, null);
      default:
    }
  }

  void handleGetUserStateChanged(
    BuildContext context,
    LoaderState<AuthResOrLost<HttpResponse<GetUserResponse>>> loaderState,
  ) {
    switch (loaderState) {
      case LoaderLoadedState(data: final response):
        switch (response) {
          case AuthLost(message: final message):
            goToLogin(context, message);
          case AuthRes(data: final response):
            switch (response) {
              case HttpResponseSuccess(data: final response):
                switch (response) {
                  case FailedToLoadProfilePicture():
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute<void>(
                        builder: (_) => const PhotoInstructionsPage(),
                      ),
                    );
                  case GetUserSuccess():
                    switch (context.exploreBloc.state) {
                      case LoaderLoadedState(data: final response):
                        switch (response) {
                          case AuthRes(data: final response):
                            switch (response) {
                              case HttpResponseSuccess():
                                context.navBarBloc
                                    .add(const NavBarSetLoadingEvent(null));
                              default:
                            }
                          default:
                        }
                      default:
                    }
                }
              case HttpResponseFailure(failure: final failure):
                StyledBanner.show(
                  message: failure.message,
                  error: true,
                );
                context.userBloc
                    .add(LoaderLoadEvent(AuthReq(null, context.sessionLoader)));
            }
        }
      default:
    }
  }

  void handleExploreStateChanged(BuildContext context,
      LoaderState<AuthResOrLost<HttpResponse<List<UserExplore>>>> loaderState) {
    switch (loaderState) {
      case LoaderLoadedState(data: final response):
        switch (response) {
          case AuthLost(message: final message):
            goToLogin(context, message);
          case AuthRes(data: final response):
            switch (response) {
              case HttpResponseSuccess(data: final users):
                context.homeBloc.add(HomeLoadedExploreEvent(users));
                switch (context.userBloc.state) {
                  case LoaderLoadedState(data: final response):
                    switch (response) {
                      case AuthRes(data: final response):
                        switch (response) {
                          case HttpResponseSuccess(data: final response):
                            switch (response) {
                              case GetUserSuccess():
                                context.navBarBloc
                                    .add(const NavBarSetLoadingEvent(null));
                              default:
                            }
                          default:
                        }
                      default:
                    }
                  default:
                }
              case HttpResponseFailure():
                context.exploreBloc
                    .add(LoaderLoadEvent(AuthReq(null, context.sessionLoader)));
            }
        }
      default:
    }
  }

  void handleExploreStateChangedOnExplorePage(BuildContext context,
      LoaderState<AuthResOrLost<HttpResponse<List<UserExplore>>>> loaderState) {
    switch (loaderState) {
      case LoaderLoadedState(data: final response):
        switch (response) {
          case AuthRes(data: final response):
            switch (response) {
              case HttpResponseFailure(failure: final failure):
                StyledBanner.show(
                  message: failure.message,
                  error: true,
                );
              default:
            }
          default:
        }
      default:
    }
  }

  void handleNavBarStateChanged(
      BuildContext context, NavBarState navBarState) {}

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
            listener: handleLogoutStateChanged,
            builder: (context, logoutState) => UserConsumer(
              listener: handleGetUserStateChanged,
              builder: (context, userState) => ExploreConsumer(
                  listener: handleExploreStateChanged,
                  builder: (context, exploreState) => NavBar(
                        listener: handleNavBarStateChanged,
                        builder: (context, navBarState) => Container(),
                      )),
            ),
          ),
          // LogoutConsumer(
          //   listener: handleLogoutStateChanged,
          //   builder: (context, logoutState) => switch (logoutState) {
          //     LoaderLoadingState() || LoaderLoadedState() => const Loader(),
          //     LoaderInitialState() => UserConsumer(
          //         listener: handleGetUserStateChanged,
          //         builder: (context, userLoaderState) =>
          //             switch (userLoaderState) {
          //           LoaderInitialState() ||
          //           LoaderLoadingState() =>
          //             const Loader(),
          //           LoaderLoadedState(data: final getUserResponse) => switch (
          //                 getUserResponse) {
          //               AuthLost() => const Loader(),
          //               AuthRes(data: final getUserResponse) => switch (
          //                     getUserResponse) {
          //                   HttpResponseFailure() => const Loader(),
          //                   HttpResponseSuccess(data: final getUserResponse) =>
          //                     switch (getUserResponse) {
          //                       FailedToLoadProfilePicture() => const Loader(),
          //                       GetUserSuccess(
          //                         user: final user,
          //                         profilePicture: final profilePicture
          //                       ) =>
          //                         ExploreConsumer(
          //                           listener: handleExploreStateChanged,
          //                           builder: (context, exploreState) =>
          //                               BlocConsumer<HomeBloc, HomeState>(
          //                             listener: handleHomeStateChanged,
          //                             builder: (context, homeState) => NavBar(
          //                               state: homeState,
          //                               builder: (context) => Expanded(
          //                                 child: switch (homeState.page) {
          //                                   NavBarPage.news => const Column(
          //                                       mainAxisAlignment:
          //                                           MainAxisAlignment.center,
          //                                       children: [
          //                                         Text('News screen'),
          //                                         Text('Coming soon'),
          //                                       ],
          //                                     ),
          //                                   NavBarPage.explore =>
          //                                     ExploreConsumer(
          //                                       listener:
          //                                           // ignore: lines_longer_than_80_chars
          //                                           handleExploreStateChangedOnExplorePage,
          //                                       builder:
          //                                           (context, exploreState) =>
          //                                               switch (exploreState) {
          //                                         LoaderLoadedState(
          //                                           data: final exploreResponse
          //                                         ) =>
          //                                           switch (exploreResponse) {
          //                                             AuthRes(
          //                                               data:
          //                                                   // ignore: lines_longer_than_80_chars
          //                                                   final exploreResponse
          //                                             ) =>
          //                                               switch (
          //                                                   exploreResponse) {
          //                                                 HttpResponseSuccess(
          //                                                   data: final users
          //                                                 ) =>
          //                                                   ExploreScreen(
          //                                                     users: users,
          //                                                     // ignore: lines_longer_than_80_chars
          //                                                     pageController: context
          //                                                         .homeBloc
          //                                                         // ignore: lines_longer_than_80_chars
          //                                                         .explorePageController,
          //                                                     // ignore: lines_longer_than_80_chars
          //                                                     countdown: switch (
          //                                                         homeState) {
          //                                                       // ignore: lines_longer_than_80_chars
          //                                                       HomeHoldingLogoState(
          //                                                         countdown:
          //                                                             // ignore: lines_longer_than_80_chars
          //                                                             final countdown
          //                                                       ) =>
          //                                                         countdown,
          //                                                       _ => null,
          //                                                     },
          //                                                   ),
          //                                                 _ => const Loader(),
          //                                               },
          //                                             _ => const Loader(),
          //                                           },
          //                                         _ => const Loader(),
          //                                       },
          //                                     ),
          //                                   NavBarPage.chat => const Column(
          //                                       mainAxisAlignment:
          //                                           MainAxisAlignment.center,
          //                                       children: [
          //                                         Text('Chat screen'),
          //                                         Text('Coming soon'),
          //                                       ],
          //                                     ),
          //                                   NavBarPage.options => Column(
          //                                       mainAxisAlignment:
          //                                           MainAxisAlignment.center,
          //                                       children: [
          //                                         Text('${user.firstName}'
          //                                             ' ${user.lastName}'),
          //                                         20.verticalSpace,
          //                                         profilePicture,
          //                                         StyledOutlineButton(
          //                                           onPress: () => context
          //                                               .logoutBloc
          //                                               .add(LoaderLoadEvent((
          //                                             data: null,
          //                                             sessionLoader:
          //                                                 context.sessionLoader
          //                                           ))),
          //                                           text: 'Logout',
          //                                         ),
          //                                       ],
          //                                     ),
          //                                 },
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                     },
          //                 }
          //             },
          //         },
          //       )
          // },
          // ),
        ),
      );
}
