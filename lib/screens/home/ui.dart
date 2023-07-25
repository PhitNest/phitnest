import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import '../../widgets/widgets.dart';
import '../login_screen.dart';
import '../profile_photo/instructions.dart';
import 'explore/ui.dart';

final class UserExplore extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final Image profilePicture;

  const UserExplore({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  }) : super();

  @override
  List<Object?> get props => [id, firstName, lastName, profilePicture];
}

Future<HttpResponse<List<UserExplore>>> explore(Session session) async =>
    request(
      route: '/explore',
      method: HttpMethod.get,
      session: session,
      parser: (json) => switch (json) {
        List() => (json)
            .map(
              (entry) => switch (entry) {
                ({
                  'id': final String id,
                  'firstName': final String firstName,
                  'lastName': final String lastName,
                  'identityId': final String identityId,
                }) =>
                  (
                    id: id,
                    firstName: firstName,
                    lastName: lastName,
                    identityId: identityId,
                  ),
                _ => throw const Failure(
                    'InvalidResponse', 'Invalid response from server.'),
              },
            )
            .toList(),
        _ => throw const Failure(
            'InvalidResponse', 'Invalid response from server.'),
      },
    ).then(
      (res) async => switch (res) {
        HttpResponseSuccess(data: final data, headers: final headers) =>
          HttpResponseOk(
            await Future.wait(
              data.map(
                (entry) async {
                  final pfp = await getProfilePicture(
                    session,
                    entry.identityId,
                  );
                  if (pfp != null) {
                    return UserExplore(
                      id: entry.id,
                      firstName: entry.firstName,
                      lastName: entry.lastName,
                      profilePicture: pfp,
                    );
                  }
                  return null;
                },
              ),
            ).then(
              (users) => users
                  .where((element) => element != null)
                  .cast<UserExplore>()
                  .toList(),
            ),
            headers,
          ),
        HttpResponseFailure(failure: final failure, headers: final headers) =>
          HttpResponseFailure(
            failure,
            headers,
          ),
      },
    );

sealed class ExploreState extends Equatable {
  const ExploreState() : super();
}

final class ExploreInitialState extends ExploreState {
  const ExploreInitialState() : super();

  @override
  List<Object?> get props => [];
}

final class ExploreLoadedState extends ExploreState {
  final List<UserExplore> users;

  const ExploreLoadedState({
    required this.users,
  }) : super();

  @override
  List<Object?> get props => [users];
}

sealed class ExploreEvent extends Equatable {
  const ExploreEvent() : super();
}

final class ExploreLoadedEvent extends ExploreEvent {
  final List<UserExplore> users;

  const ExploreLoadedEvent(this.users) : super();

  @override
  List<Object?> get props => [users];
}

final class ExploreSendFriendRequestEvent extends ExploreEvent {
  final int exploreListIndex;

  const ExploreSendFriendRequestEvent(this.exploreListIndex) : super();

  @override
  List<Object?> get props => [exploreListIndex];
}

final class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final PageController pageController = PageController();

  ExploreBloc() : super(const ExploreInitialState()) {
    on<ExploreLoadedEvent>(
      (event, emit) {
        emit(ExploreLoadedState(users: event.users));
      },
    );

    on<ExploreSendFriendRequestEvent>(
      (event, emit) {
        switch (state) {
          case ExploreLoadedState(users: final users):
            emit(ExploreLoadedState(
                users: users..removeAt(event.exploreListIndex)));
          default:
            badState(state, event);
        }
      },
    );
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}

void goToLogin(
  BuildContext context,
  ApiInfo apiInfo,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute<void>(
        builder: (context) => LoginScreen(apiInfo: apiInfo),
      ),
      (_) => false,
    );

typedef PfpBloc = LoaderBloc<void, Image?>;
typedef PfpConsumer = LoaderConsumer<void, Image?>;
typedef LogoutBloc = LoaderBloc<void, void>;
typedef LogoutConsumer = LoaderConsumer<void, void>;
typedef ExploreRequestBloc = LoaderBloc<void, HttpResponse<List<UserExplore>>?>;
typedef ExploreRequestConsumer
    = LoaderConsumer<void, HttpResponse<List<UserExplore>>?>;

extension on BuildContext {
  ExploreRequestBloc get exploreBloc => loader();
  LogoutBloc get logoutBloc => loader();
  ExploreBloc get homeBloc => BlocProvider.of(this);
  NavBarBloc get navbarBloc => BlocProvider.of(this);
}

class HomeScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const HomeScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ExploreBloc(),
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
            ),
            BlocProvider(
              create: (context) => ExploreRequestBloc(
                load: (_) async {
                  final session = await context.sessionLoader.session;
                  if (session != null) {
                    return await explore(session);
                  }
                  return null;
                },
                loadOnStart: (req: null),
              ),
            ),
            BlocProvider(
              create: (context) => PfpBloc(
                load: (_) async {
                  final session = await context.sessionLoader.session;
                  if (session != null) {
                    return await getProfilePicture(
                        session, session.credentials.userIdentityId!);
                  }
                  return null;
                },
                loadOnStart: (req: null),
              ),
            ),
          ],
          child: PfpConsumer(
            listener: (context, pfpState) {
              switch (pfpState) {
                case LoaderLoadedState(data: final image):
                  if (image == null) {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute<void>(
                        builder: (context) => PhotoInstructionsScreen(
                          apiInfo: apiInfo,
                        ),
                      ),
                    );
                  }
                default:
              }
            },
            builder: (context, pfpState) => switch (pfpState) {
              LoaderLoadedState(data: final image) => image != null
                  ? LogoutConsumer(
                      listener: (context, logoutState) {
                        switch (logoutState) {
                          case LoaderLoadedState():
                            goToLogin(context, apiInfo);
                          default:
                        }
                      },
                      builder: (context, logoutState) => switch (logoutState) {
                        LoaderLoadingState() => const Loader(),
                        _ => ExploreRequestConsumer(
                            listener: (context, exploreRequestState) {
                              switch (exploreRequestState) {
                                case LoaderLoadedState(data: final response):
                                  if (response != null) {
                                    switch (response) {
                                      case HttpResponseSuccess(
                                          data: final users
                                        ):
                                        context.homeBloc
                                            .add(ExploreLoadedEvent(users));
                                      case HttpResponseFailure():
                                        context.exploreBloc
                                            .add(const LoaderLoadEvent(null));
                                    }
                                  } else {
                                    goToLogin(context, apiInfo);
                                  }
                                default:
                              }
                            },
                            builder: (context, exploreRequestState) =>
                                StyledNavBar(
                              listener: (context, navBarState) async {
                                switch (navBarState) {
                                  case NavBarActiveState():
                                    switch (exploreRequestState) {
                                      case LoaderLoadingState():
                                        context.navbarBloc.add(
                                            const NavBarSetLoadingEvent(true));
                                      default:
                                    }
                                  default:
                                }
                              },
                              builder: (context, navBarState) => Expanded(
                                child: switch (navBarState.page) {
                                  NavBarPage.news => const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('News screen'),
                                        Text('Coming soon'),
                                      ],
                                    ),
                                  NavBarPage.explore => ExploreRequestConsumer(
                                      listener: (context, exploreState) {
                                        switch (exploreState) {
                                          case LoaderLoadedState(
                                              data: final response
                                            ):
                                            switch (response) {
                                              case HttpResponseFailure(
                                                  failure: final failure
                                                ):
                                                StyledBanner.show(
                                                  message: failure.message,
                                                  error: true,
                                                );
                                              default:
                                            }
                                          default:
                                        }
                                      },
                                      builder: (context, exploreRequestState) =>
                                          BlocConsumer<ExploreBloc,
                                              ExploreState>(
                                        listener: (context, exploreState) {},
                                        builder: (context, exploreState) =>
                                            switch (exploreState) {
                                          ExploreLoadedState(
                                            users: final users
                                          ) =>
                                            ExploreScreen(
                                              users: users,
                                              pageController: context
                                                  .homeBloc.pageController,
                                            ),
                                          _ => const Loader()
                                        },
                                      ),
                                    ),
                                  NavBarPage.chat => const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Chat screen'),
                                        Text('Coming soon'),
                                      ],
                                    ),
                                  NavBarPage.options => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Options screen'),
                                        20.verticalSpace,
                                        image,
                                        StyledOutlineButton(
                                          onPress: () => context.logoutBloc
                                              .add(const LoaderLoadEvent(null)),
                                          text: 'Logout',
                                        ),
                                      ],
                                    ),
                                },
                              ),
                            ),
                          ),
                      },
                    )
                  : const Loader(),
              _ => const Loader(),
            },
          ),
        ),
      );
}
