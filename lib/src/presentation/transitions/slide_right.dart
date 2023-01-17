import 'package:flutter/material.dart';

class SlideRightTransition extends PageRouteBuilder {
  final Widget page;
  SlideRightTransition({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: animation.drive(
              Tween(
                begin: Offset.zero,
                end: const Offset(1.0, 0.0),
              ).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
            ),
            child: child,
          ),
        );
}
