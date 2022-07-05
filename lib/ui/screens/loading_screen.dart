import 'package:flutter/material.dart';
import 'package:phitnest/ui/common/widgets/loading/loading_wheel.dart';

import '../common/textStyles/text_styles.dart';

const MAX_NUM_DOTS = 4;

const DOT_DURATION = Duration(milliseconds: 2000);

// Increase this to shift the loading text left, decrease to shift right
const TEXT_OFFSET = 83;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _dotController =
      AnimationController(vsync: this, duration: DOT_DURATION)..repeat();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      LoadingWheel(),
      Container(
          padding: EdgeInsets.only(
              left: (MediaQuery.of(context).size.width - TEXT_OFFSET) / 2),
          constraints: BoxConstraints(minWidth: double.infinity),
          child: AnimatedBuilder(
            animation: _dotController,
            builder: (_, child) {
              String displayText = 'loading';
              int numDots =
                  (_dotController.value * MAX_NUM_DOTS).floor() % MAX_NUM_DOTS;
              for (int i = 0; i < numDots; i++) {
                displayText += '.';
              }
              return Text(displayText,
                  textAlign: TextAlign.left,
                  style: HeadingTextStyle(size: TextSize.MEDIUM));
            },
          ))
    ])));
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }
}
