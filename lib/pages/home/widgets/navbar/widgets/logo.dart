const kLogoAnimationWidth = 8;
const kLogoWidth = 36.62;
Image _image(double animation, NavBarState state) => Image.asset(
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
  final NavBarState state;

  const NavBarLogo({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case NavBarLoadingState(page: final page) ||
            NavBarSendingFriendRequestState(page: final page):
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
          NavBarHoldingLogoState() => _image(1, state),
          NavBarReversedState() || NavBarLoadingState() => _image(0, state),
          NavBarLoadedState(
            page: final page,
            exploreUsers: final exploreUsers
          ) =>
            switch (page) {
              NavBarPage.explore => exploreUsers.isNotEmpty
                  ? NavBarAnimation(state: state)
                  : _image(0, state),
              _ => _image(0, state),
            },
        });
  }
}
