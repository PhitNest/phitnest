import 'package:flutter/material.dart';

import '../../../common/textStyles/text_styles.dart';
import '../../../common/widgets/widgets.dart';

/// This is the view for a single onBoarding page
class OnBoardingPageWidget extends StatelessWidget {
  final dynamic image;
  final String title;
  final String subTitle;
  final bool isLastPage;

  const OnBoardingPageWidget(
      {Key? key,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.isLastPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        image == null
            ? LogoWidget(
                color: Colors.white,
              )
            : Icon(
                image as IconData,
                color: Colors.white,
                size: 150,
              ),
        Text(
          title.toUpperCase(),
          style: HeadingTextStyle(size: TextSize.SMALL, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            subTitle,
            style: BodyTextStyle(size: TextSize.SMALL, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
