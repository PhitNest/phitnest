import 'package:flutter/material.dart';
import 'package:phitnest/ui/common/textStyles/text_styles.dart';
import 'package:phitnest/ui/screens/models.dart';

import '../../../common/widgets/widgets.dart';

class OnBoardingPage extends StatelessWidget {
  final String path;
  final String text;
  final Function() onClickContinue;
  final int pageNum;

  const OnBoardingPage({
    Key? key,
    required this.path,
    required this.text,
    required this.pageNum,
    required this.onClickContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double vertPadding = MediaQuery.of(context).size.height / 20;

    return Scaffold(
        body: Stack(children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageWidget(
            path: path,
            padding: EdgeInsets.only(top: vertPadding * 2, bottom: vertPadding),
          ),
          Text(text,
              style: HeadingTextStyle(
                size: TextSize.MEDIUM,
                color: Colors.black,
              )),
        ],
      ),
      Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        // The button is only shown on the last page
        Visibility(
            visible: pageNum == OnBoardingModel.pages.length - 1,
            child: StyledButton(
              key: Key("onBoarding_continue"),
              minWidth: 300,
              textColor: Colors.black,
              text: "Let's get phit!",
              onClick: onClickContinue,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildDots(vertPadding).toList(),
        )
      ])
    ]));
  }

  /// Build the page indicator dots at the bottom of the screen
  Iterable<Widget> buildDots(double vertPadding) sync* {
    for (int i = 0; i < OnBoardingModel.pages.length; i++) {
      yield Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: vertPadding),
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
