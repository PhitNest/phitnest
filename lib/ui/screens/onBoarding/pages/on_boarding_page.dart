import 'package:flutter/material.dart';
import 'package:phitnest/ui/common/textStyles/text_styles.dart';
import 'package:phitnest/ui/screens/models.dart';

import '../../../common/widgets/widgets.dart';

class OnBoardingPage extends StatelessWidget {
  static const double VERTICAL_PADDING = 32.0;

  final String path;
  final String? text;
  final double heightFactor;
  final Function() onClickContinue;
  final int pageNum;

  const OnBoardingPage({
    Key? key,
    required this.path,
    required this.text,
    required this.heightFactor,
    required this.pageNum,
    required this.onClickContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Stack(children: [
        Center(
            heightFactor: heightFactor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageWidget(
                  path: path,
                  padding: EdgeInsets.only(bottom: VERTICAL_PADDING),
                ),
                text == null
                    ? Container()
                    : Text(text!,
                        style: HeadingTextStyle(
                          size: TextSize.MEDIUM,
                          color: Colors.black,
                        )),
                // The button is only shown on the last page
                Visibility(
                    visible: pageNum == OnBoardingModel.pages.length - 1,
                    child: StyledButton(
                      key: Key("onBoarding_continue"),
                      minWidth: 300,
                      text: "Let's get phit!",
                      onClick: onClickContinue,
                    )),
              ],
            )),
        Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildDots().toList(),
            ))
      ]));

  /// Build the page indicator dots at the bottom of the screen
  Iterable<Widget> buildDots() sync* {
    for (int i = 0; i < OnBoardingModel.pages.length; i++) {
      yield Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 32.0),
          child: Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: i == pageNum ? Colors.grey : Colors.grey.shade300),
          ));
    }
  }
}
