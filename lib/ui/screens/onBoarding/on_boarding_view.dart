import 'package:display/display.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../views.dart';
import 'widgets/on_boarding_page_widget.dart';

/// This view will only be shown to the user one time. If it has already been
/// shown, or the user is authenticated, they will be redirected accordingly.
class OnBoardingView extends BaseView {
  final dynamic image;
  final String title;
  final String subtitle;
  final PageController pageController;
  final int numPages;
  final bool isLastPage;
  final Function(int newPage) onPageChange;
  final Function() onClickContinue;

  const OnBoardingView({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.pageController,
    required this.numPages,
    required this.isLastPage,
    required this.onPageChange,
    required this.onClickContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        body: Stack(children: <Widget>[
          PageView.builder(
              itemBuilder: (context, index) => OnBoardingPageWidget(
                  image: image,
                  title: title,
                  subTitle: subtitle,
                  isLastPage: isLastPage),
              controller: pageController,
              itemCount: numPages,
              onPageChanged: onPageChange),
          // Only show the continue button if this is the last page
          Visibility(
            visible: isLastPage,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Directionality.of(context) == TextDirection.ltr
                      ? Alignment.bottomRight
                      : Alignment.bottomLeft,
                  child: OutlinedButton(
                    // Set on boarding finished to true and redirect to auth.
                    onPressed: onClickContinue,
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white),
                        shape: StadiumBorder()),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(
                controller: pageController,
                count: numPages,
                effect: ScrollingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.grey.shade400,
                    dotWidth: 8,
                    dotHeight: 8,
                    fixedCenter: true),
              ),
            ),
          )
        ]),
      );
}