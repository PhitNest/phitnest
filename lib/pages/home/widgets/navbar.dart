import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../home.dart';
import 'styled_indicator.dart';

const kLogoAnimationWidth = 8;
const kLogoWidth = 36.62;
Image _image(double animation, HomeState state) => Image.asset(
      state.logoAssetPath!,
      width: kLogoWidth.w + animation * kLogoAnimationWidth.w,
    );

final class NavBarAnimation extends StatefulWidget {
  final HomeState state;

  const NavBarAnimation({
    super.key,
    required this.state,
  }) : super();

  @override
  NavBarAnimationState createState() => NavBarAnimationState();
}

final class NavBarAnimationState extends State<NavBarAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(vsync: this)
    ..repeat(
      min: 0,
      max: 1,
      reverse: true,
      period: const Duration(milliseconds: 1200),
    );

  NavBarAnimationState() : super();

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: controller,
      builder: (context, child) => _image(controller.value, widget.state));

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

enum AnimationState {
  animating,
  small,
  large,
}

final class NavBarLogo extends StatelessWidget {
  final HomeState state;

  const NavBarLogo({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case HomeLoadingState(page: final page) ||
            HomeSendingFriendRequestState(page: final page):
        if (page == NavBarPage.explore) {
          return const CircularProgressIndicator();
        }
      default:
    }

    return GestureDetector(
        onTapCancel: () => context.homeBloc.add(const HomeReleaseLogoEvent()),
        onTapDown: (_) => context.homeBloc.add(const HomePressLogoEvent()),
        onTapUp: (_) => context.homeBloc.add(const HomeReleaseLogoEvent()),
        child: switch (state) {
          HomeHoldingLogoState() => _image(1, state),
          HomeMatchedState() ||
          HomeSendingFriendRequestState() ||
          HomeLoadingState() =>
            _image(0, state),
          HomeLoadedState(page: final page, exploreUsers: final exploreUsers) =>
            switch (page) {
              NavBarPage.explore => exploreUsers.isNotEmpty
                  ? NavBarAnimation(state: state)
                  : _image(0, state),
              _ => _image(0, state),
            },
        });
  }
}

final class NavBarPageButton extends StatelessWidget {
  final String text;
  final bool selected;
  final bool reversed;
  final VoidCallback onPressed;

  const NavBarPageButton({
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
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
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

class NavBar extends StatelessWidget {
  static double get kHeight => 66.h;
  final HomeState state;
  final Widget Function(BuildContext context) builder;

  const NavBar({
    super.key,
    required this.builder,
    required this.state,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          builder(context),
          Container(
            height: NavBar.kHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: switch (state) {
                HomeMatchedState() => Colors.black,
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
                      child: NavBarLogo(
                        state: state,
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final bool reversed = state is HomeMatchedState;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NavBarPageButton(
                            text: 'NEWS',
                            selected: state.page == NavBarPage.news,
                            reversed: reversed,
                            onPressed: () => context.homeBloc
                                .add(const HomePressPageEvent(NavBarPage.news)),
                          ),
                          NavBarPageButton(
                            text: 'EXPLORE',
                            selected: state.page == NavBarPage.explore,
                            reversed: reversed,
                            onPressed: () => context.homeBloc.add(
                                const HomePressPageEvent(NavBarPage.explore)),
                          ),
                          60.horizontalSpace,
                          StyledIndicator(
                            offset: const Size(8, 8),
                            count: 0,
                            child: NavBarPageButton(
                              text: 'CHAT',
                              selected: state.page == NavBarPage.chat,
                              reversed: reversed,
                              onPressed: () => context.homeBloc.add(
                                  const HomePressPageEvent(NavBarPage.chat)),
                            ),
                          ),
                          NavBarPageButton(
                            text: 'OPTIONS',
                            selected: state.page == NavBarPage.options,
                            reversed: reversed,
                            onPressed: () => context.homeBloc.add(
                                const HomePressPageEvent(NavBarPage.options)),
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
      );
}
