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

final class NavBarLoadingState extends NavBarState {
  final NavBarLoadingReason reason;

  @override
  String? get logoAssetPath =>
      page == NavBarPage.explore ? null : Assets.logo.path;

  const NavBarLoadingState({
    required super.page,
    required this.reason,
  }) : super();

  @override
  List<Object?> get props => [...super.props, reason];
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
  final NavBarLoadingReason? reason;

  const NavBarSetLoadingEvent(this.reason) : super();

  @override
  List<Object?> get props => [reason];
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
  NavBarBloc()
      : super(const NavBarLoadingState(
            page: NavBarPage.explore, reason: NavBarLoadingReason.explore)) {
    on<NavBarSetLoadingEvent>(
      (event, emit) {
        if (event.reason != null) {
          emit(NavBarLoadingState(page: state.page, reason: event.reason!));
        } else {
          emit(NavBarInactiveState(page: state.page));
        }
      },
    );

    on<NavBarPressPageEvent>(
      (event, emit) async {
        switch (state) {
          case NavBarLoadingState(reason: final reason):
            emit(NavBarLoadingState(page: event.page, reason: reason));
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
          case NavBarLoadingState(reason: final reason):
            emit(NavBarLoadingState(page: NavBarPage.explore, reason: reason));
            break;
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
              emit(const NavBarLoadingState(
                  page: NavBarPage.explore,
                  reason: NavBarLoadingReason.sendRequest));
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
          case NavBarLoadingState(reason: final reason):
            switch (reason) {
              case NavBarLoadingReason.explore:
                badState(state, event);
              case NavBarLoadingReason.sendRequest:
                emit(const NavBarReversedState());
            }
        }
      },
    );

    on<NavBarAnimateEvent>(
      (event, emit) {
        switch (state) {
          case NavBarInactiveState() ||
                NavBarLoadingState() ||
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
