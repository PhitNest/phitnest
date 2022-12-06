import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/screens.dart';
import '../theme.dart';
import 'no_animation_page_route.dart';
import 'widgets.dart';

class StyledNavBar extends StatefulWidget {
  static double get kHeight => 66.h;

  final int pageIndex;
  final bool animateLogo;
  final VoidCallback onTapDownLogo;
  final VoidCallback? onTapUpLogo;
  final bool reversed;
  final bool navigationEnabled;
  final bool colorful;

  static const String kColoredLogoPath = 'assets/images/logo_color.png';
  static const String kLogoPath = 'assets/images/logo.png';
  static const String kReversedLogoPath = 'assets/images/logo_reversed.png';

  const StyledNavBar({
    Key? key,
    required this.navigationEnabled,
    required this.pageIndex,
    required this.onTapDownLogo,
    this.colorful = false,
    this.reversed = false,
    this.animateLogo = false,
    this.onTapUpLogo,
  }) : super(key: key);

  StyledNavBar copyWith({
    bool? navigationEnabled,
    int? pageIndex,
    Function()? onTapDownLogo,
    bool? reversed,
    bool? animateLogo,
    Function()? onTapUpLogo,
  }) =>
      StyledNavBar(
        navigationEnabled: navigationEnabled ?? this.navigationEnabled,
        pageIndex: pageIndex ?? this.pageIndex,
        reversed: reversed ?? this.reversed,
        animateLogo: animateLogo ?? this.animateLogo,
        onTapDownLogo: onTapDownLogo ?? this.onTapDownLogo,
        onTapUpLogo: onTapUpLogo ?? this.onTapUpLogo,
      );

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
      onTapCancel: widget.onTapUpLogo,
      onTapDown: (_) => widget.onTapDownLogo(),
      onTapUp: widget.onTapUpLogo == null ? null : (_) => widget.onTapUpLogo!(),
      child: Image.asset(
        widget.colorful
            ? widget.reversed
                ? StyledNavBar.kReversedLogoPath
                : StyledNavBar.kColoredLogoPath
            : StyledNavBar.kLogoPath,
        width:
            38.62.w + (widget.animateLogo ? (controller?.value ?? 0) : 1) * 5.w,
      ));

  Widget createButton(
          BuildContext context, String text, Function() onPressed, int index) =>
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
          style: index == widget.pageIndex
              ? theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.reversed ? Colors.white : Colors.black)
              : theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.reversed
                      ? Color.fromARGB((0.7 * 255).round(), 255, 255, 255)
                      : Color.fromARGB((0.4 * 255).round(), 0, 0, 0),
                ),
        ),
        onPressed: widget.navigationEnabled && index != widget.pageIndex
            ? onPressed
            : null,
      );

  @override
  Widget build(BuildContext context) => Container(
        height: StyledNavBar.kHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.reversed ? Colors.black : Colors.white,
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
                          : logoButton)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  createButton(
                      context,
                      'NEWS',
                      () => Navigator.pushAndRemoveUntil(
                          context,
                          NoAnimationMaterialPageRoute(
                            builder: (context) => NewsProvider(),
                          ),
                          (route) => false),
                      0),
                  createButton(
                      context,
                      'EXPLORE',
                      () => Navigator.pushAndRemoveUntil(
                          context,
                          NoAnimationMaterialPageRoute(
                            builder: (context) => ExploreProvider(),
                          ),
                          (route) => false),
                      1),
                  60.horizontalSpace,
                  createButton(
                      context,
                      'CHAT',
                      () => Navigator.pushAndRemoveUntil(
                          context,
                          NoAnimationMaterialPageRoute(
                            builder: (context) => ConversationsProvider(),
                          ),
                          (route) => false),
                      2),
                  createButton(
                    context,
                    'OPTIONS',
                    () => Navigator.pushAndRemoveUntil(
                        context,
                        NoAnimationMaterialPageRoute(
                          builder: (context) => OptionsProvider(),
                        ),
                        (route) => false),
                    3,
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