import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../navbar.dart';

const kLogoAnimationWidth = 8;
const kLogoWidth = 36.62;

Image _logoImage(double animation, NavBarState state) => Image.asset(
      state.logoAssetPath!,
      width: kLogoWidth.w + animation * kLogoAnimationWidth.w,
    );

final class NavBarAnimation extends StatefulWidget {
  final NavBarState state;

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
      builder: (context, child) => _logoImage(controller.value, widget.state));

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

final class NavBarLogo extends StatelessWidget {
  final NavBarState state;

  const NavBarLogo({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case NavBarLoadingState(page: final page):
        if (page == NavBarPage.explore) {
          return const CircularProgressIndicator();
        }
      default:
    }

    return GestureDetector(
        onTapCancel: () =>
            context.navBarBloc.add(const NavBarReleaseLogoEvent()),
        onTapDown: (_) => context.navBarBloc.add(const NavBarPressLogoEvent()),
        onTapUp: (_) => context.navBarBloc.add(const NavBarReleaseLogoEvent()),
        child: switch (state) {
          NavBarHoldingLogoState() => _logoImage(1, state),
          NavBarInactiveState() ||
          NavBarReversedState() ||
          NavBarLoadingState() =>
            _logoImage(0, state),
          NavBarLogoReadyState() => NavBarAnimation(state: state),
        });
  }
}
