import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants/constants.dart';
import '../../../common/theme.dart';

enum NavbarPage { news, explore, chat, options }

class NavbarState {
  final NavbarPage page;
  final bool animateLogo;
  final bool darkMode;
  final bool colorful;

  const NavbarState({
    required this.page,
    required this.animateLogo,
    required this.darkMode,
    required this.colorful,
  }) : super();
}

class StyledNavBar extends StatefulWidget {
  static double get kHeight => 66.h;

  final NavbarPage page;
  final bool animateLogo;
  final bool darkMode;
  final bool colorful;
  final VoidCallback onPressDownLogo;
  final VoidCallback onReleaseLogo;
  final VoidCallback onPressedNews;
  final VoidCallback onPressedExplore;
  final VoidCallback onPressedChat;
  final VoidCallback onPressedOptions;

  const StyledNavBar({
    required this.page,
    required this.onReleaseLogo,
    required this.onPressDownLogo,
    required this.onPressedNews,
    required this.onPressedExplore,
    required this.onPressedChat,
    required this.onPressedOptions,
    this.colorful = false,
    this.darkMode = false,
    this.animateLogo = false,
  }) : super();

  @override
  State<StatefulWidget> createState() => _StyledNavBarState();
}

class _StyledNavBarState extends State<StyledNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller = widget.colorful
        ? (AnimationController(vsync: this)
          ..repeat(
            min: 0,
            max: 1,
            reverse: true,
            period: Duration(milliseconds: 1200),
          ))
        : null;
  }

  Widget get logoButton => GestureDetector(
      onTapCancel: widget.onReleaseLogo,
      onTapDown: (_) => widget.onPressDownLogo(),
      onTapUp: (_) => widget.onReleaseLogo(),
      child: Image.asset(
        widget.colorful
            ? widget.darkMode
                ? Assets.darkLogo.path
                : Assets.coloredLogo.path
            : Assets.logo.path,
        width:
            38.62.w + (widget.animateLogo ? (controller?.value ?? 0) : 1) * 5.w,
      ));

  Widget createButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
    NavbarPage page,
  ) =>
      TextButton(
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
          style: page == widget.page
              ? theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.darkMode ? Colors.white : Colors.black)
              : theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.darkMode
                      ? Color.fromARGB((0.7 * 255).round(), 255, 255, 255)
                      : Color.fromARGB((0.4 * 255).round(), 0, 0, 0),
                ),
        ),
        onPressed: page != widget.page ? onPressed : null,
      );

  @override
  Widget build(BuildContext context) => Container(
        height: StyledNavBar.kHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.darkMode ? Colors.black : Colors.white,
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
                  child: controller != null
                      ? AnimatedBuilder(
                          animation: controller!,
                          builder: (context, child) => logoButton,
                        )
                      : logoButton,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  createButton(
                    context,
                    'NEWS',
                    widget.onPressedNews,
                    NavbarPage.news,
                  ),
                  createButton(
                    context,
                    'EXPLORE',
                    widget.onPressedExplore,
                    NavbarPage.explore,
                  ),
                  60.horizontalSpace,
                  createButton(
                    context,
                    'CHAT',
                    widget.onPressedChat,
                    NavbarPage.chat,
                  ),
                  createButton(
                    context,
                    'OPTIONS',
                    widget.onPressedOptions,
                    NavbarPage.options,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
