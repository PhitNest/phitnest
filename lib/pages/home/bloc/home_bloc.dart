part of '../home.dart';

enum NavBarPage { news, explore, chat, options }

sealed class HomeState extends Equatable {
  final NavBarPage page;
  String? get logoAssetPath;

  const HomeState({
    required this.page,
  }) : super();

  @override
  List<Object?> get props => [page, logoAssetPath];
}

final class HomeLoadingState extends HomeState {
  @override
  String? get logoAssetPath =>
      page == NavBarPage.explore ? null : Assets.logo.path;

  const HomeLoadingState({
    required super.page,
  }) : super();
}

sealed class HomeLoadedBaseState extends HomeState {
  final List<UserExplore> exploreUsers;

  @override
  String? get logoAssetPath =>
      page == NavBarPage.explore && exploreUsers.isNotEmpty
          ? Assets.coloredLogo.path
          : Assets.logo.path;

  const HomeLoadedBaseState({
    required super.page,
    required this.exploreUsers,
  }) : super();

  @override
  List<Object?> get props => [super.props, exploreUsers];
}

final class HomeLoadedState extends HomeLoadedBaseState {
  const HomeLoadedState({
    required super.page,
    required super.exploreUsers,
  }) : super();
}

final class HomeHoldingLogoState extends HomeLoadedBaseState {
  final int countdown;
  final CancelableOperation<void> nextCount;

  const HomeHoldingLogoState({
    required super.exploreUsers,
    required this.countdown,
    required this.nextCount,
  }) : super(page: NavBarPage.explore);

  @override
  List<Object?> get props => [super.props, countdown, nextCount];
}

final class HomeSendingFriendRequestState extends HomeLoadedBaseState {
  final UserExplore user;
  final int userIndex;

  @override
  String? get logoAssetPath =>
      page == NavBarPage.explore ? null : Assets.logo.path;

  const HomeSendingFriendRequestState({
    required super.exploreUsers,
    required super.page,
    required this.user,
    required this.userIndex,
  }) : super();

  @override
  List<Object?> get props => [super.props, userIndex, user];
}

final class HomeMatchedState extends HomeLoadedBaseState {
  final UserExplore matchedUser;

  @override
  String? get logoAssetPath => Assets.darkLogo.path;

  const HomeMatchedState({
    required super.exploreUsers,
    required this.matchedUser,
  }) : super(page: NavBarPage.explore);

  @override
  List<Object?> get props => [super.props, matchedUser];
}

sealed class HomeEvent extends Equatable {
  const HomeEvent() : super();
}

final class HomePressPageEvent extends HomeEvent {
  final NavBarPage page;

  const HomePressPageEvent(this.page) : super();

  @override
  List<Object?> get props => [page];
}

final class HomeLoadedExploreEvent extends HomeEvent {
  final List<UserExplore> exploreUsers;

  const HomeLoadedExploreEvent(this.exploreUsers) : super();

  @override
  List<Object?> get props => [exploreUsers];
}

final class HomePressLogoEvent extends HomeEvent {
  const HomePressLogoEvent() : super();

  @override
  List<Object?> get props => [];
}

final class HomeReleaseLogoEvent extends HomeEvent {
  const HomeReleaseLogoEvent() : super();

  @override
  List<Object?> get props => [];
}

final class HomeSentFriendRequestEvent extends HomeEvent {
  const HomeSentFriendRequestEvent() : super();

  @override
  List<Object?> get props => [];
}

final class HomeFriendRequestNotSentEvent extends HomeEvent {
  const HomeFriendRequestNotSentEvent() : super();

  @override
  List<Object?> get props => [];
}

final class HomeCountDownEvent extends HomeEvent {
  const HomeCountDownEvent() : super();

  @override
  List<Object?> get props => [];
}

final class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PageController explorePageController = PageController();

  HomeBloc() : super(const HomeLoadingState(page: NavBarPage.explore)) {
    on<HomeLoadedExploreEvent>(
      (event, emit) {
        switch (state) {
          case HomeLoadingState(
              page: final page,
            ):
            emit(
              HomeLoadedState(
                page: page,
                exploreUsers: event.exploreUsers,
              ),
            );
          default:
            badState(state, event);
        }
      },
    );

    on<HomePressPageEvent>(
      (event, emit) async {
        switch (state) {
          case HomeMatchedState(exploreUsers: final exploreUsers) ||
                HomeLoadedState(exploreUsers: final exploreUsers):
            emit(HomeLoadedState(page: event.page, exploreUsers: exploreUsers));
          case HomeLoadingState():
            emit(HomeLoadingState(page: event.page));
          case HomeSendingFriendRequestState(
              exploreUsers: final exploreUsers,
              userIndex: final userIndex,
              user: final user
            ):
            emit(HomeSendingFriendRequestState(
              page: event.page,
              exploreUsers: exploreUsers,
              user: user,
              userIndex: userIndex,
            ));
          case HomeHoldingLogoState(
              nextCount: final nextCount,
              exploreUsers: final exploreUsers
            ):
            await nextCount.cancel();
            emit(HomeLoadedState(page: event.page, exploreUsers: exploreUsers));
        }
      },
    );

    on<HomePressLogoEvent>(
      (event, emit) {
        switch (state) {
          case HomeHoldingLogoState():
            badState(state, event);
          case HomeMatchedState(exploreUsers: final exploreUsers):
            emit(HomeLoadedState(
                page: NavBarPage.explore, exploreUsers: exploreUsers));
          case HomeLoadingState():
            emit(const HomeLoadingState(page: NavBarPage.explore));
          case HomeSendingFriendRequestState(
              exploreUsers: final exploreUsers,
              user: final user,
              userIndex: final userIndex
            ):
            emit(HomeSendingFriendRequestState(
                exploreUsers: exploreUsers,
                page: NavBarPage.explore,
                user: user,
                userIndex: userIndex));
          case HomeLoadedState(
              exploreUsers: final exploreUsers,
              page: final page
            ):
            switch (page) {
              case NavBarPage.explore:
                if (exploreUsers.isNotEmpty) {
                  emit(
                    HomeHoldingLogoState(
                      countdown: 3,
                      exploreUsers: exploreUsers,
                      nextCount: CancelableOperation.fromFuture(
                          Future.delayed(const Duration(seconds: 1)))
                        ..then(
                          (_) => add(
                            const HomeCountDownEvent(),
                          ),
                        ),
                    ),
                  );
                }
              case NavBarPage.chat || NavBarPage.options || NavBarPage.news:
                emit(
                  HomeLoadedState(
                      page: NavBarPage.explore, exploreUsers: exploreUsers),
                );
            }
        }
      },
    );

    on<HomeReleaseLogoEvent>(
      (event, emit) async {
        switch (state) {
          case HomeHoldingLogoState(
              nextCount: final nextCount,
              exploreUsers: final exploreUsers,
            ):
            await nextCount.cancel();
            emit(HomeLoadedState(
              exploreUsers: exploreUsers,
              page: NavBarPage.explore,
            ));
          case HomeLoadedState() ||
                HomeLoadingState() ||
                HomeSendingFriendRequestState():
            break;
          default:
            badState(state, event);
        }
      },
    );

    on<HomeSentFriendRequestEvent>((event, emit) {
      switch (state) {
        case HomeSendingFriendRequestState(
            exploreUsers: final exploreUsers,
            user: final user
          ):
          emit(HomeMatchedState(
            exploreUsers: exploreUsers,
            matchedUser: user,
          ));
        default:
          badState(state, event);
      }
    });

    on<HomeFriendRequestNotSentEvent>(
      (event, emit) {
        switch (state) {
          case HomeSendingFriendRequestState(
              exploreUsers: final exploreUsers,
              userIndex: final userIndex,
              user: final user
            ):
            emit(HomeLoadedState(
              exploreUsers: [
                ...exploreUsers.sublist(0, userIndex),
                user,
                ...exploreUsers.sublist(userIndex + 1),
              ],
              page: NavBarPage.explore,
            ));
          default:
            badState(state, event);
        }
      },
    );

    on<HomeCountDownEvent>(
      (event, emit) {
        switch (state) {
          case HomeHoldingLogoState(
              countdown: final countdown,
              exploreUsers: final exploreUsers,
            ):
            if (countdown > 1) {
              emit(
                HomeHoldingLogoState(
                  exploreUsers: exploreUsers,
                  countdown: countdown - 1,
                  nextCount: CancelableOperation.fromFuture(
                      Future.delayed(const Duration(seconds: 1)))
                    ..then(
                      (_) => add(
                        const HomeCountDownEvent(),
                      ),
                    ),
                ),
              );
            } else {
              final index =
                  explorePageController.page!.round() % exploreUsers.length;
              emit(
                HomeSendingFriendRequestState(
                  exploreUsers: [
                    ...exploreUsers.sublist(0, index),
                    ...exploreUsers.sublist(index + 1),
                  ],
                  user: exploreUsers[index],
                  page: NavBarPage.explore,
                  userIndex: index,
                ),
              );
            }
          default:
            badState(state, event);
        }
      },
    );
  }

  @override
  Future<void> close() async {
    switch (state) {
      case HomeHoldingLogoState(
          nextCount: final nextCount,
        ):
        await nextCount.cancel();
      default:
    }
    explorePageController.dispose();
    return super.close();
  }
}

extension HomeBlocGetter on BuildContext {
  HomeBloc get homeBloc => BlocProvider.of(this);
}
