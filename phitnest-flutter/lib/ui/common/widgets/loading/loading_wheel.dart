import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets.dart';

const SPIN_DURATION = Duration(milliseconds: 1000);

class LoadingWheel extends StatefulWidget {
  final double scale;
  final EdgeInsets padding;
  final Color? color;

  const LoadingWheel(
      {Key? key,
      this.color,
      this.scale = 1,
      this.padding = const EdgeInsets.all(20.0)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingWheelState();
}

class _LoadingWheelState extends State<LoadingWheel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: SPIN_DURATION)..repeat();

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) => Transform.rotate(
            angle: _animationController.value * 2 * pi,
            child: LogoWidget(
              color: widget.color,
              scale: 0.35 * widget.scale,
              padding: widget.padding,
            ),
          ));

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
