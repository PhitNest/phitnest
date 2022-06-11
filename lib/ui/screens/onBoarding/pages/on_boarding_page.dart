import 'package:flutter/material.dart';
import 'package:phitnest/ui/screens/models.dart';

import '../../../../constants/constants.dart';
import '../../../common/textStyles/text_styles.dart';
import '../../../common/widgets/widgets.dart';

class OnBoardingPage extends StatelessWidget {
  final String path;
  final String text;
  final Function() onClickContinue;
  final int pageNum;

  static const List<Color> backgroundColors = [
    Colors.white,
    Color(LOGO_OUTER_RING)
  ];

  static List<Color> dotColors = [Colors.grey, Colors.grey.shade300];

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
        backgroundColor: backgroundColors[pageNum % 2],
        body: Stack(children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageWidget(
                path: path,
                padding:
                    EdgeInsets.only(top: vertPadding * 3, bottom: vertPadding),
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
                  buttonColor: Color.fromARGB(255, 208, 233, 236),
                  text: "Let's get phit!",
                  onClick: onClickContinue,
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: vertPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: buildDots().toList(),
                )),
          ])
        ]));
  }

  /// Build the page indicator dots at the bottom of the screen
  Iterable<Widget> buildDots() sync* {
    for (int i = 0; i < OnBoardingModel.pages.length; i++) {
      yield Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  // If this dot is for the current page, and the background is
                  // light, the dot is dark.
                  // If this dot is for the current page, and the background is
                  // dark, the dot is light
                  // If this dot is not for the current page, and the background
                  // is light, the dot is light
                  // If this dot is not for the current page, and the background
                  // is dark, the dot is dark
                  color: dotColors[(i == pageNum ? 0 : 1) ^ (pageNum % 2)])));
    }
  }
}
