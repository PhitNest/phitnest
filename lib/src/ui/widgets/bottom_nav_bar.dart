import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/screens.dart';
import '../theme.dart';
import 'no_animation_page_route.dart';
import 'widgets.dart';

/// These are the pages on the nav bar.
enum NavbarPage { news, explore, chat, options }

class StyledNavBar extends StatefulWidget {
  static double get kHeight => 66.h;

  final NavbarPage page;
  final bool animateLogo;
  final VoidCallback? onPressDownLogo;
  final VoidCallback? onReleaseLogo;
  final bool darkMode;
  final bool navigationEnabled;
  final bool colorful;
  final GlobalKey? gestureKey;

  static const String kColoredLogoPath = 'assets/images/logo_color.png';
  static const String kLogoPath = 'assets/images/logo.png';
  static const String kDarkLogoPath = 'assets/images/logo_reversed.png';

  const StyledNavBar({
    required this.page,
    this.gestureKey,
    this.onReleaseLogo,
    this.onPressDownLogo,
    this.navigationEnabled = true,
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
      key: widget.gestureKey,
      onTapCancel: widget.onReleaseLogo,
      onTapDown: (_) => widget.onPressDownLogo != null
          ? widget.onPressDownLogo!()
          : Navigator.pushAndRemoveUntil(
              context,
              NoAnimationMaterialPageRoute(
                builder: (context) => ExploreProvider(),
              ),
              (route) => false,
            ),
      onTapUp:
          widget.onReleaseLogo != null ? (_) => widget.onReleaseLogo!() : null,
      child: Image.asset(
        widget.colorful
            ? widget.darkMode
                ? StyledNavBar.kDarkLogoPath
                : StyledNavBar.kColoredLogoPath
            : StyledNavBar.kLogoPath,
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
        onPressed:
            widget.navigationEnabled && page != widget.page ? onPressed : null,
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
                    () {},
                    // () => Navigator.pushAndRemoveUntil(
                    //   context,
                    //   NoAnimationMaterialPageRoute(
                    //     builder: (context) => const NewsProvider(),
                    //   ),
                    //   (route) => false,
                    // ),
                    NavbarPage.news,
                  ),
                  createButton(
                    context,
                    'EXPLORE',
                    () => Navigator.pushAndRemoveUntil(
                      context,
                      NoAnimationMaterialPageRoute(
                        builder: (context) => ExploreProvider(),
                      ),
                      (route) => false,
                    ),
                    NavbarPage.explore,
                  ),
                  60.horizontalSpace,
                  createButton(
                    context,
                    'CHAT',
                    () => Navigator.pushAndRemoveUntil(
                      context,
                      NoAnimationMaterialPageRoute(
                        builder: (context) => ConversationsProvider(),
                      ),
                      (route) => false,
                    ),
                    NavbarPage.chat,
                  ),
                  createButton(
                    context,
                    'OPTIONS',
                    () => Navigator.pushAndRemoveUntil(
                      context,
                      NoAnimationMaterialPageRoute(
                        builder: (context) => OptionsProvider(),
                      ),
                      (route) => false,
                    ),
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
