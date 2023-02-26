import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants/constants.dart';
import '../../../common/theme.dart';
import '../widgets.dart';

enum NavbarPage { news, explore, chat, options }

enum LogoState { animated, holding, disabled, reversed, loading }

extension _LogoStateToAsset on LogoState {
  String? get assetPath {
    switch (this) {
      case LogoState.animated:
      case LogoState.holding:
        return Assets.coloredLogo.path;
      case LogoState.disabled:
        return Assets.logo.path;
      case LogoState.reversed:
        return Assets.darkLogo.path;
      default:
        return null;
    }
  }
}

class _StyledNavBarLogo extends StatefulWidget {
  final LogoState state;
  final VoidCallback onReleased;
  final VoidCallback onPressed;

  const _StyledNavBarLogo({
    Key? key,
    required this.state,
    required this.onReleased,
    required this.onPressed,
  }) : super(key: key);

  @override
  _StyledNavBarLogoState createState() => _StyledNavBarLogoState();
}

class _StyledNavBarLogoState extends State<_StyledNavBarLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController? controller;

  @override
  void initState() {
    super.initState();
    if (widget.state.assetPath != null) {
      controller = AnimationController(vsync: this)
        ..repeat(
          min: 0,
          max: 1,
          reverse: true,
          period: Duration(milliseconds: 1200),
        );
    }
  }

  @override
  Widget build(BuildContext context) => widget.state.assetPath != null
      ? GestureDetector(
          onTapCancel: widget.onReleased,
          onTapDown: (_) => widget.onPressed(),
          onTapUp: (_) => widget.onReleased(),
          child: AnimatedBuilder(
            animation: controller!,
            builder: (context, child) => Image.asset(
              widget.state.assetPath!,
              width: 38.62.w +
                  (widget.state == LogoState.animated
                          ? controller!.value
                          : widget.state == LogoState.holding
                              ? 1
                              : 0) *
                      5.w,
            ),
          ),
        )
      : CircularProgressIndicator();

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class _StyledNavBarPageButton extends StatelessWidget {
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
            maximumSize: MaterialStateProperty.all(
              Size.fromWidth(78.w),
            ),
            minimumSize: MaterialStateProperty.all(
              Size.fromWidth(78.w),
            ),
            overlayColor: MaterialStateProperty.all(
              Colors.transparent,
            )),
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
        onPressed: !selected ? onPressed : null,
      );
}

class StyledNavBar extends StatelessWidget {
  static double get kHeight => 66.h;

  final NavbarPage page;
  final LogoState logoState;
  final VoidCallback onPressDownLogo;
  final VoidCallback onReleaseLogo;
  final VoidCallback onPressedNews;
  final VoidCallback onPressedExplore;
  final VoidCallback onPressedChat;
  final VoidCallback onPressedOptions;
  final int friendRequestCount;

  const StyledNavBar({
    required this.page,
    required this.logoState,
    required this.onReleaseLogo,
    required this.onPressDownLogo,
    required this.onPressedNews,
    required this.onPressedExplore,
    required this.onPressedChat,
    required this.onPressedOptions,
    required this.friendRequestCount,
  }) : super();

  @override
  Widget build(BuildContext context) => Container(
        height: StyledNavBar.kHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: logoState == LogoState.reversed ? Colors.black : Colors.white,
          boxShadow: [
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
                    state: logoState,
                    onReleased: onReleaseLogo,
                    onPressed: onPressDownLogo,
                  ),
                ),
              ),
              Builder(
                builder: (context) {
                  final bool reversed = logoState == LogoState.reversed;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StyledNavBarPageButton(
                        text: 'NEWS',
                        selected: page == NavbarPage.news,
                        reversed: reversed,
                        onPressed: onPressedNews,
                      ),
                      _StyledNavBarPageButton(
                        text: 'EXPLORE',
                        selected: page == NavbarPage.explore,
                        reversed: reversed,
                        onPressed: onPressedExplore,
                      ),
                      60.horizontalSpace,
                      StyledIndicator(
                        offset: Size(8, 8),
                        child: _StyledNavBarPageButton(
                          text: 'CHAT',
                          selected: page == NavbarPage.chat,
                          reversed: reversed,
                          onPressed: onPressedChat,
                        ),
                        count: friendRequestCount,
                      ),
                      _StyledNavBarPageButton(
                        text: 'OPTIONS',
                        selected: page == NavbarPage.options,
                        reversed: reversed,
                        onPressed: onPressedOptions,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
}
