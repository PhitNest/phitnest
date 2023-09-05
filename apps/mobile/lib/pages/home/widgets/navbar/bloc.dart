part of 'navbar.dart';

enum NavBarPage { news, explore, chat, options }

sealed class NavBarState extends Equatable {
  final NavBarPage page;
  String? get logoAssetPath;

  const NavBarState({
    required this.page,
  }) : super();

  @override
  List<Object?> get props => [page, logoAssetPath];
}

enum NavBarLoadingReason { explore, sendRequest }

sealed class NavBarLoadingBaseState extends NavBarState {
  @override
  String? get logoAssetPath =>
      page == NavBarPage.explore ? null : Assets.logo.path;

  const NavBarLoadingBaseState({
    required super.page,
  }) : super();
}

final class NavBarInitialState extends NavBarLoadingBaseState {
  const NavBarInitialState({
    required super.page,
  }) : super();
}

final class NavBarSendingFriendRequestState extends NavBarLoadingBaseState {
  @override
  String? get logoAssetPath =>
      page == NavBarPage.explore ? null : Assets.logo.path;

  const NavBarSendingFriendRequestState({
    required super.page,
  }) : super();
}

final class NavBarInactiveState extends NavBarState {
  @override
  String? get logoAssetPath => Assets.logo.path;

  const NavBarInactiveState({
    required super.page,
  }) : super();
}

sealed class NavBarActiveState extends NavBarState {
  @override
  String? get logoAssetPath => Assets.coloredLogo.path;

  const NavBarActiveState() : super(page: NavBarPage.explore);
}

final class NavBarLogoReadyState extends NavBarActiveState {
  const NavBarLogoReadyState() : super();
}

final class NavBarHoldingLogoState extends NavBarActiveState {
  final int countdown;
  final CancelableOperation<void> nextCount;

  const NavBarHoldingLogoState(this.countdown, this.nextCount) : super();

  @override
  List<Object?> get props => [...super.props, countdown, nextCount];
}

final class NavBarReversedState extends NavBarActiveState {
  @override
  String? get logoAssetPath => Assets.darkLogo.path;

  const NavBarReversedState() : super();
}

sealed class NavBarEvent extends Equatable {
  const NavBarEvent() : super();
}

final class NavBarPressPageEvent extends NavBarEvent {
  final NavBarPage page;

  const NavBarPressPageEvent(this.page) : super();

  @override
  List<Object?> get props => [page];
}

final class NavBarSetLoadingEvent extends NavBarEvent {
  final bool loading;

  const NavBarSetLoadingEvent(this.loading) : super();

  @override
  List<Object?> get props => [loading];
}

final class NavBarPressLogoEvent extends NavBarEvent {
  const NavBarPressLogoEvent() : super();

  @override
  List<Object?> get props => [];
}

final class NavBarReleaseLogoEvent extends NavBarEvent {
  const NavBarReleaseLogoEvent() : super();

  @override
  List<Object?> get props => [];
}

final class NavBarCancelLogoEvent extends NavBarEvent {
  const NavBarCancelLogoEvent() : super();

  @override
  List<Object?> get props => [];
}

final class NavBarCountDownEvent extends NavBarEvent {
  const NavBarCountDownEvent() : super();

  @override
  List<Object?> get props => [];
}

final class NavBarReverseEvent extends NavBarEvent {
  const NavBarReverseEvent() : super();

  @override
  List<Object?> get props => [];
}

final class NavBarAnimateEvent extends NavBarEvent {
  const NavBarAnimateEvent() : super();

  @override
  List<Object?> get props => [];
}

final class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(const NavBarInitialState(page: NavBarPage.explore)) {
    on<NavBarSetLoadingEvent>(
      (event, emit) {
        if (event.loading) {
          emit(NavBarInitialState(page: state.page));
        } else {
          emit(NavBarInactiveState(page: state.page));
        }
      },
    );

    on<NavBarPressPageEvent>(
      (event, emit) async {
        switch (state) {
          case NavBarInitialState() || NavBarSendingFriendRequestState():
            emit(NavBarInitialState(page: event.page));
          case NavBarReversedState() ||
                NavBarInactiveState() ||
                NavBarLogoReadyState():
            emit(NavBarInactiveState(page: event.page));
          case NavBarHoldingLogoState(
              nextCount: final nextCount,
            ):
            await nextCount.cancel();
            emit(NavBarInactiveState(page: event.page));
        }
      },
    );

    on<NavBarPressLogoEvent>(
      (event, emit) {
        switch (state) {
          case NavBarLogoReadyState():
            emit(NavBarHoldingLogoState(
                3,
                CancelableOperation.fromFuture(
                    Future.delayed(const Duration(seconds: 1)))
                  ..then((_) => add(const NavBarCountDownEvent()))));
          case NavBarHoldingLogoState():
            badState(state, event);
          default:
        }
      },
    );

    on<NavBarReleaseLogoEvent>(
      (event, emit) async {
        switch (state) {
          case NavBarHoldingLogoState(nextCount: final nextCount):
            await nextCount.cancel();
            emit(const NavBarInactiveState(page: NavBarPage.explore));
          case NavBarInactiveState() ||
                NavBarReversedState() ||
                NavBarLogoReadyState():
            emit(const NavBarInactiveState(page: NavBarPage.explore));
          case NavBarInitialState():
            emit(const NavBarInitialState(page: NavBarPage.explore));
            break;
          case NavBarSendingFriendRequestState():
            emit(const NavBarSendingFriendRequestState(
                page: NavBarPage.explore));
        }
      },
    );

    on<NavBarCancelLogoEvent>(
      (event, emit) async {
        switch (state) {
          case NavBarHoldingLogoState(nextCount: final nextCount):
            await nextCount.cancel();
            emit(const NavBarInactiveState(page: NavBarPage.explore));
          default:
        }
      },
    );

    on<NavBarCountDownEvent>(
      (event, emit) {
        switch (state) {
          case NavBarHoldingLogoState(countdown: final countdown):
            if (countdown > 1) {
              emit(
                NavBarHoldingLogoState(
                  countdown - 1,
                  CancelableOperation.fromFuture(
                      Future.delayed(const Duration(seconds: 1)))
                    ..then(
                      (_) => add(
                        const NavBarCountDownEvent(),
                      ),
                    ),
                ),
              );
            } else {
              emit(const NavBarSendingFriendRequestState(
                  page: NavBarPage.explore));
            }
          default:
            badState(state, event);
        }
      },
    );

    on<NavBarReverseEvent>(
      (event, emit) {
        switch (state) {
          case NavBarInactiveState() ||
                NavBarLogoReadyState() ||
                NavBarReversedState() ||
                NavBarHoldingLogoState():
            badState(state, event);
          case NavBarInitialState() || NavBarSendingFriendRequestState():
            emit(const NavBarReversedState());
        }
      },
    );

    on<NavBarAnimateEvent>(
      (event, emit) {
        switch (state) {
          case NavBarInactiveState() ||
                NavBarInitialState() ||
                NavBarSendingFriendRequestState() ||
                NavBarReversedState():
            emit(const NavBarLogoReadyState());
          case NavBarLogoReadyState() || NavBarHoldingLogoState():
            badState(state, event);
        }
      },
    );
  }

  @override
  Future<void> close() async {
    switch (state) {
      case NavBarHoldingLogoState(
          nextCount: final nextCount,
        ):
        await nextCount.cancel();
      default:
    }
    return super.close();
  }
}

extension NavBarBlocGetter on BuildContext {
  NavBarBloc get navBarBloc => BlocProvider.of(this);
}

void _handleNavBarStateChanged(
  BuildContext context,
  PageController pageController,
  NavBarState state,
) {
  switch (context.userBloc.state) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case AuthRes(data: final response):
          switch (response) {
            case HttpResponseSuccess(
                data: final response,
                headers: final headers,
              ):
              switch (response) {
                case GetUserSuccess(exploreUsers: final exploreUsers):
                  switch (state) {
                    case NavBarInactiveState(page: final page):
                      if (page == NavBarPage.explore) {
                        if (exploreUsers.isNotEmpty) {
                          context.navBarBloc.add(const NavBarAnimateEvent());
                        }
                      }
                    case NavBarSendingFriendRequestState():
                      final currentPage =
                          pageController.page!.round() % exploreUsers.length;
                      context.userBloc.add(
                        LoaderSetEvent(
                          AuthRes(
                            HttpResponseOk(
                              response.copyWith(
                                exploreUsers: [...exploreUsers]
                                  ..removeAt(currentPage),
                              ),
                              headers,
                            ),
                          ),
                        ),
                      );
                      context.sendFriendRequestBloc.add(LoaderLoadEvent(AuthReq(
                          exploreUsers[currentPage].user.id,
                          context.sessionLoader)));
                    default:
                  }
                default:
              }
            default:
          }
        default:
      }
    default:
  }
}
