import 'dart:math';

import 'package:device/device.dart';
import 'package:flutter/material.dart';

import '../../textStyles/text_styles.dart';
import '../widgets.dart';

const MAX_NUM_DOTS = 3;

// INCREASE THIS TO SHIFT THE LOADING TEXT LEFT, DECREASE TO SHIFT RIGHT
const TEXT_OFFSET = 75;

class LoadingWidget extends StatefulWidget {
  final String? text;

  const LoadingWidget({required Key key, this.text}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
        ..repeat();

  int numDots = 0;

  @override
  Widget build(BuildContext context) {
    String text = widget.text ?? 'loading';

    for (int i = 0; i < numDots; i++) {
      text += '.';
    }

    numDots = (numDots + 1) % (MAX_NUM_DOTS + 1);

    Future.delayed(Duration(milliseconds: 250), () {
      try {
        setState(() {});
      } catch (ignored) {}
    });

    return Scaffold(
        backgroundColor: primaryColor,
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AnimatedBuilder(
              animation: _controller,
              builder: (_, child) => Transform.rotate(
                    angle: _controller.value * 2 * pi,
                    child: LogoWidget(
                      padding: EdgeInsets.all(20),
                      scale: 0.25,
                      color: Colors.white,
                    ),
                  )),
          Container(
              padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width - TEXT_OFFSET) / 2),
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Text(
                text,
                textAlign: TextAlign.left,
                style:
                    HeadingTextStyle(size: TextSize.SMALL, color: Colors.white),
              ))
        ])));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
