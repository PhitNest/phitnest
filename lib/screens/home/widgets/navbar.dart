part of '../home.dart';

enum AnimationState {
  animating,
  small,
  large,
}

final class StyledNavBarLogo extends StatefulWidget {
  final HomeState state;

  const StyledNavBarLogo({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  StyledNavBarLogoState createState() => StyledNavBarLogoState();
}

final class StyledNavBarLogoState extends State<StyledNavBarLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(vsync: this)
    ..repeat(
      min: 0,
      max: 1,
      reverse: true,
      period: const Duration(milliseconds: 1200),
    );

  StyledNavBarLogoState() : super();

  @override
  Widget build(BuildContext context) => switch (widget.state) {
        HomeLoadingState() ||
        HomeSendingFriendRequestState() =>
          const CircularProgressIndicator(),
        _ => GestureDetector(
            onTapCancel: () =>
                context.homeBloc.add(const HomeReleaseLogoEvent()),
            onTapDown: (_) => context.homeBloc.add(const HomePressLogoEvent()),
            onTapUp: (_) => context.homeBloc.add(const HomeReleaseLogoEvent()),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) =>
                  Image.asset(widget.state.logoAssetPath!,
                      width: 38.62.w +
                          switch (widget.state) {
                                HomeHoldingLogoState() => 1,
                                HomeMatchedState() => 0,
                                HomeLoadedState(page: final page) => switch (
                                      page) {
                                    NavBarPage.explore => controller.value,
                                    _ => 0,
                                  },
                                HomeLoadingState() ||
                                HomeSendingFriendRequestState() =>
                                  throw Exception('invalid state'),
                              } *
                              5.w),
            ),
          ),
      };

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

final class StyledNavBarPageButton extends StatelessWidget {
  final String text;
  final bool selected;
  final bool reversed;
  final VoidCallback onPressed;

  const StyledNavBarPageButton({
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
  final HomeState state;
  final Widget Function(BuildContext context) builder;

  const StyledNavBar({
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
            height: StyledNavBar.kHeight,
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
                      child: StyledNavBarLogo(
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
                          StyledNavBarPageButton(
                            text: 'NEWS',
                            selected: state.page == NavBarPage.news,
                            reversed: reversed,
                            onPressed: () => context.homeBloc
                                .add(const HomePressPageEvent(NavBarPage.news)),
                          ),
                          StyledNavBarPageButton(
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
                            child: StyledNavBarPageButton(
                              text: 'CHAT',
                              selected: state.page == NavBarPage.chat,
                              reversed: reversed,
                              onPressed: () => context.homeBloc.add(
                                  const HomePressPageEvent(NavBarPage.chat)),
                            ),
                          ),
                          StyledNavBarPageButton(
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
