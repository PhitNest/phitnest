import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/screens.dart';
import 'no_animation_page_route.dart';
import 'widgets.dart';

class StyledNavBar extends StatefulWidget {
  static double get kHeight => 66.h;

  final int pageIndex;
  final bool logoHeld;
  final Function() onTapDownLogo;
  final Function() onTapUpLogo;
  final bool reversed;
  final bool navigationEnabled;

  static const String kColoredLogoPath = 'assets/images/logo_color.png';
  static const String kLogoPath = 'assets/images/logo.png';
  static const String kReversedLogoPath = 'assets/images/logo_reversed.png';

  const StyledNavBar(
      {Key? key,
      required this.navigationEnabled,
      required this.pageIndex,
      required this.onTapDownLogo,
      this.reversed = false,
      this.logoHeld = false,
      required this.onTapUpLogo})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StyledNavBarState();
}

class _StyledNavBarState extends State<StyledNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController? controller;

  bool get shouldAnimate => widget.pageIndex == 1 && !widget.reversed;

  @override
  void initState() {
    super.initState();
    controller = shouldAnimate
        ? (AnimationController(vsync: this)
          ..repeat(
              min: 0,
              max: 1,
              reverse: true,
              period: Duration(milliseconds: 1200)))
        : null;
  }

  Widget get logoButton => GestureDetector(
      onTapCancel: widget.onTapUpLogo,
      onTapDown: (_) => widget.onTapDownLogo(),
      onTapUp: (_) => widget.onTapUpLogo(),
      child: Image.asset(
        widget.pageIndex == 1
            ? widget.reversed
                ? StyledNavBar.kReversedLogoPath
                : StyledNavBar.kColoredLogoPath
            : StyledNavBar.kLogoPath,
        width: 38.62.w + (widget.logoHeld ? 1 : (controller?.value ?? 0)) * 5.w,
      ));

  Widget createButton(
          BuildContext context, String text, Function() onPressed, int index) =>
      TextButton(
          style: ButtonStyle(
              maximumSize: MaterialStateProperty.all(Size.fromWidth(78.w)),
              minimumSize: MaterialStateProperty.all(Size.fromWidth(78.w)),
              overlayColor: MaterialStateProperty.all(Colors.transparent)),
          child: Text(text,
              style: index == widget.pageIndex
                  ? Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.reversed ? Colors.white : Colors.black)
                  : Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: widget.reversed
                          ? Color.fromARGB((0.8 * 255).round(), 255, 255, 255)
                          : Color.fromARGB((0.8 * 255).round(), 0, 0, 0))),
          onPressed: widget.navigationEnabled && index != widget.pageIndex
              ? onPressed
              : null);

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
        child: Ink(
            width: double.infinity,
            height: double.maxFinite,
            child: Stack(children: [
              Center(
                  child: Padding(
                      padding: EdgeInsets.only(left: 12.w, bottom: 12.h),
                      child: controller != null
                          ? AnimatedBuilder(
                              animation: controller!,
                              builder: (context, child) => logoButton)
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
                              builder: (context) => NewsProvider()),
                          (route) => false),
                      0),
                  createButton(
                      context,
                      'EXPLORE',
                      () => Navigator.pushAndRemoveUntil(
                          context,
                          NoAnimationMaterialPageRoute(
                              builder: (context) => ExploreProvider()),
                          (route) => false),
                      1),
                  60.horizontalSpace,
                  createButton(
                      context,
                      'CHAT',
                      () => Navigator.pushAndRemoveUntil(
                          context,
                          NoAnimationMaterialPageRoute(
                              builder: (context) => ChatProvider()),
                          (route) => false),
                      2),
                  createButton(
                      context,
                      'OPTIONS',
                      () => Navigator.pushAndRemoveUntil(
                          context,
                          NoAnimationMaterialPageRoute(
                              builder: (context) => OptionsProvider()),
                          (route) => false),
                      3),
                ],
              ),
            ])),
      );

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
