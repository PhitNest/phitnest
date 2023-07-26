import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import '../common/constants/constants.dart';
import 'styled_indicator.dart';
import 'widgets.dart';

enum NavBarPage { news, explore, chat, options }

sealed class NavBarState extends Equatable {
  NavBarPage get page;
  String? get assetPath;

  const NavBarState() : super();
}

final class NavBarNormalState extends NavBarState {
  @override
  String? get assetPath => Assets.logo.path;

  @override
  final NavBarPage page;

  const NavBarNormalState(this.page)
      : assert(page != NavBarPage.explore),
        super();

  @override
  List<Object?> get props => [page];
}

sealed class NavBarExploreState extends NavBarState {
  @override
  NavBarPage get page => NavBarPage.explore;

  const NavBarExploreState() : super();

  @override
  List<Object?> get props => [];
}

final class NavBarLoadingState extends NavBarExploreState {
  @override
  String? get assetPath => null;

  const NavBarLoadingState() : super();
}

final class NavBarActiveState extends NavBarExploreState {
  @override
  String? get assetPath => Assets.coloredLogo.path;

  const NavBarActiveState() : super();
}

final class NavBarInactiveState extends NavBarExploreState {
  @override
  String? get assetPath => Assets.logo.path;

  const NavBarInactiveState() : super();
}

final class NavBarHoldingState extends NavBarExploreState {
  final int countdown;
  final CancelableOperation<void> nextCount;

  @override
  String? get assetPath => Assets.coloredLogo.path;

  const NavBarHoldingState(this.countdown, this.nextCount) : super();

  @override
  List<Object?> get props => [countdown, nextCount];
}

final class NavBarReversedState extends NavBarExploreState {
  @override
  String? get assetPath => Assets.darkLogo.path;

  const NavBarReversedState() : super();
}

final class NavBarCountdownEndedState extends NavBarExploreState {
  @override
  String? get assetPath => Assets.coloredLogo.path;

  const NavBarCountdownEndedState() : super();
}

sealed class NavBarEvent extends Equatable {
  const NavBarEvent() : super();
}

final class NavBarPressEvent extends NavBarEvent {
  final NavBarPage page;

  const NavBarPressEvent(this.page) : super();

  @override
  List<Object?> get props => [page];
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

final class NavBarReverseEvent extends NavBarEvent {
  const NavBarReverseEvent() : super();

  @override
  List<Object?> get props => [];
}

final class NavBarSetLoadingEvent extends NavBarEvent {
  final bool loading;

  const NavBarSetLoadingEvent(this.loading) : super();

  @override
  List<Object?> get props => [loading];
}

final class NavBarCountDownEvent extends NavBarEvent {
  const NavBarCountDownEvent() : super();

  @override
  List<Object?> get props => [];
}

final class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(const NavBarLoadingState()) {
    on<NavBarPressEvent>(
      (event, emit) {
        switch (state) {
          case NavBarNormalState() ||
                NavBarCountdownEndedState() ||
                NavBarReversedState():
            switch (event.page) {
              case NavBarPage.explore:
                emit(const NavBarActiveState());
              case NavBarPage.chat || NavBarPage.options || NavBarPage.news:
                emit(NavBarNormalState(event.page));
            }
          case NavBarInactiveState() ||
                NavBarActiveState() ||
                NavBarLoadingState():
            switch (event.page) {
              case NavBarPage.chat || NavBarPage.options || NavBarPage.news:
                emit(NavBarNormalState(event.page));
              case NavBarPage.explore:
            }
          case NavBarHoldingState():
        }
      },
    );

    on<NavBarPressLogoEvent>(
      (event, emit) {
        switch (state) {
          case NavBarNormalState() || NavBarReversedState():
            emit(const NavBarActiveState());
          case NavBarActiveState() || NavBarCountdownEndedState():
            emit(
              NavBarHoldingState(
                3,
                CancelableOperation.fromFuture(
                  Future.delayed(const Duration(seconds: 1)),
                )..then((_) => add(const NavBarCountDownEvent())),
              ),
            );
          case NavBarInactiveState() ||
                NavBarHoldingState() ||
                NavBarLoadingState():
        }
      },
    );

    on<NavBarReleaseLogoEvent>(
      (event, emit) async {
        switch (state) {
          case NavBarHoldingState(nextCount: final nextCount):
            await nextCount.cancel();
            emit(const NavBarActiveState());
          case NavBarActiveState() ||
                NavBarNormalState() ||
                NavBarReversedState() ||
                NavBarInactiveState() ||
                NavBarLoadingState() ||
                NavBarCountdownEndedState():
        }
      },
    );

    on<NavBarReverseEvent>(
      (event, emit) => emit(const NavBarReversedState()),
    );

    on<NavBarSetLoadingEvent>(
      (event, emit) {
        if (event.loading) {
          switch (state) {
            case NavBarActiveState() || NavBarHoldingState():
              emit(const NavBarLoadingState());
            default:
          }
        } else {
          switch (state) {
            case NavBarLoadingState():
              emit(const NavBarActiveState());
            default:
          }
        }
      },
    );

    on<NavBarCountDownEvent>(
      (event, emit) {
        switch (state) {
          case NavBarHoldingState(countdown: final countdown):
            if (countdown > 1) {
              emit(NavBarHoldingState(
                countdown - 1,
                CancelableOperation.fromFuture(
                  Future.delayed(const Duration(seconds: 1)),
                )..then((_) => add(const NavBarCountDownEvent())),
              ));
            } else {
              emit(const NavBarCountdownEndedState());
            }
          case NavBarActiveState() ||
                NavBarNormalState() ||
                NavBarReversedState() ||
                NavBarCountdownEndedState() ||
                NavBarInactiveState() ||
                NavBarLoadingState():
        }
      },
    );
  }

  @override
  Future<void> close() async {
    switch (state) {
      case NavBarHoldingState(nextCount: final nextCount):
        await nextCount.cancel();
      default:
    }
    return super.close();
  }
}

extension on BuildContext {
  NavBarBloc get navBarBloc => BlocProvider.of(this);
}

final class _StyledNavBarLogo extends StatefulWidget {
  final NavBarState state;

  const _StyledNavBarLogo({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  _StyledNavBarLogoState createState() => _StyledNavBarLogoState();
}

final class _StyledNavBarLogoState extends State<_StyledNavBarLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(vsync: this)
    ..repeat(
      min: 0,
      max: 1,
      reverse: true,
      period: const Duration(milliseconds: 1200),
    );

  _StyledNavBarLogoState() : super();

  @override
  Widget build(BuildContext context) => switch (widget.state) {
        NavBarLoadingState() => const CircularProgressIndicator(),
        _ => GestureDetector(
            onTapCancel: () =>
                context.navBarBloc.add(const NavBarReleaseLogoEvent()),
            onTapDown: (_) =>
                context.navBarBloc.add(const NavBarPressLogoEvent()),
            onTapUp: (_) =>
                context.navBarBloc.add(const NavBarReleaseLogoEvent()),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) => Image.asset(widget.state.assetPath!,
                  width: 38.62.w +
                      switch (widget.state) {
                            NavBarActiveState() ||
                            NavBarCountdownEndedState() =>
                              controller.value,
                            NavBarHoldingState() => 1,
                            NavBarNormalState() ||
                            NavBarInactiveState() ||
                            NavBarReversedState() =>
                              0,
                            NavBarLoadingState() =>
                              throw Exception('This should never happen'),
                          } *
                          5.w),
            ),
          )
      };

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

final class _StyledNavBarPageButton extends StatelessWidget {
  final String text;
  final bool selected;
  final bool reversed;
  final VoidCallback onPressed;

  const _StyledNavBarPageButton({
    Key? key,
    required this.text,
    required this.selected,
    required this.reversed,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        style: ButtonStyle(
          maximumSize: MaterialStateProperty.all(Size.fromWidth(78.w)),
          minimumSize: MaterialStateProperty.all(Size.fromWidth(78.w)),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: !selected ? onPressed : null,
        child: Text(
          text,
          style: theme.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: reversed
                ? selected
                    ? Colors.white
                    : Color.fromARGB((0.7 * 255).round(), 255, 255, 255)
                : selected
                    ? Colors.black
                    : Color.fromARGB((0.4 * 255).round(), 0, 0, 0),
          ),
        ),
      );
}

class StyledNavBar extends StatelessWidget {
  static double get kHeight => 66.h;

  final Widget Function(BuildContext context, NavBarState navBarState) builder;
  final Future<void> Function(BuildContext context, NavBarState navBarState)
      listener;

  const StyledNavBar({
    super.key,
    required this.builder,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) => BlocConsumer<NavBarBloc, NavBarState>(
        listener: listener,
        builder: (context, navBarState) => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            builder(context, navBarState),
            Container(
              height: StyledNavBar.kHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: switch (navBarState) {
                  NavBarReversedState() => Colors.black,
                  _ => Colors.white,
                },
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8.5,
                    spreadRadius: 0.0,
                    color: Colors.black,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: 18.h),
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 12.w),
                        child: _StyledNavBarLogo(
                          state: navBarState,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final bool reversed =
                            navBarState is NavBarReversedState;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StyledNavBarPageButton(
                              text: 'NEWS',
                              selected: navBarState.page == NavBarPage.news,
                              reversed: reversed,
                              onPressed: () => context.navBarBloc
                                  .add(const NavBarPressEvent(NavBarPage.news)),
                            ),
                            _StyledNavBarPageButton(
                              text: 'EXPLORE',
                              selected: navBarState.page == NavBarPage.explore,
                              reversed: reversed,
                              onPressed: () => context.navBarBloc.add(
                                  const NavBarPressEvent(NavBarPage.explore)),
                            ),
                            60.horizontalSpace,
                            StyledIndicator(
                              offset: const Size(8, 8),
                              count: 0,
                              child: _StyledNavBarPageButton(
                                text: 'CHAT',
                                selected: navBarState.page == NavBarPage.chat,
                                reversed: reversed,
                                onPressed: () => context.navBarBloc.add(
                                    const NavBarPressEvent(NavBarPage.chat)),
                              ),
                            ),
                            _StyledNavBarPageButton(
                              text: 'OPTIONS',
                              selected: navBarState.page == NavBarPage.options,
                              reversed: reversed,
                              onPressed: () => context.navBarBloc.add(
                                  const NavBarPressEvent(NavBarPage.options)),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
