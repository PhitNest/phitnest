import 'dart:math';

import 'package:device/device.dart';
import 'package:flutter/material.dart';

import '../../textStyles/text_styles.dart';
import '../widgets.dart';

const SPIN_DURATION = Duration(milliseconds: 1000);

const MAX_NUM_DOTS = 4;

const DOT_DURATION = Duration(milliseconds: 2000);

// Increase this to shift the loading text left, decrease to shift right
const TEXT_OFFSET = 83;

class LoadingWidget extends StatefulWidget {
  final String? text;

  const LoadingWidget({required Key key, this.text}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late final AnimationController _spinController =
      AnimationController(vsync: this, duration: SPIN_DURATION)..repeat();
  late final AnimationController _dotController =
      AnimationController(vsync: this, duration: DOT_DURATION)..repeat();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      AnimatedBuilder(
          animation: _spinController,
          builder: (_, child) => Transform.rotate(
                angle: _spinController.value * 2 * pi,
                child: LogoWidget(
                  scale: 0.35,
                  padding: EdgeInsets.all(20),
                ),
              )),
      Container(
          padding: EdgeInsets.only(
              left: (MediaQuery.of(context).size.width - TEXT_OFFSET) / 2),
          constraints: BoxConstraints(minWidth: double.infinity),
          child: AnimatedBuilder(
            animation: _dotController,
            builder: (_, child) {
              String displayText = widget.text ?? 'loading';
              int numDots =
                  (_dotController.value * MAX_NUM_DOTS).floor() % MAX_NUM_DOTS;
              for (int i = 0; i < numDots; i++) {
                displayText += '.';
              }
              return Text(displayText,
                  textAlign: TextAlign.left,
                  style: HeadingTextStyle(
                      size: TextSize.MEDIUM, color: Colors.black));
            },
          ))
    ])));
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }
}
