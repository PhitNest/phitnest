import 'package:flutter/material.dart';

class SlideLeftTransition extends PageRouteBuilder {
  final Widget page;
  SlideLeftTransition({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
            ),
            child: child,
          ),
        );
}
