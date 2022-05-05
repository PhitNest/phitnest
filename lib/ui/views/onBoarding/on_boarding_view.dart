import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../constants/constants.dart';
import '../redirected/redirected.dart';
import 'widgets/on_boarding_page.dart';
import 'model/on_boarding_model.dart';

/// This view will only be shown to the user one time. If it has already been
/// shown, or the user is authenticated, they will be redirected accordingly.
class OnBoardingView extends PreAuthenticationView<OnBoardingModel> {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  init(BuildContext context, OnBoardingModel model) async {
    // Run the redirect logic
    await super.init(context, model);

    // Only run this if we are not redirecting to home.
    if (!await shouldRedirect) {
      // Redirect to auth if we have already seen on boarding.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(FINISHED_ON_BOARDING) ?? false) {
        Navigator.pushNamedAndRemoveUntil(context, '/auth', ((_) => false));
      } else {
        model.loading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context, OnBoardingModel model) {
    return Scaffold(
      backgroundColor: Color(COLOR_PRIMARY),
      body: Stack(children: <Widget>[
        PageView.builder(
          itemBuilder: (context, index) => OnBoardingPageWidget(
              image: model.imageList[index],
              title: model.titlesList[index],
              subTitle: model.subtitlesList[index],
              isLastPage: model.isLastPage),
          controller: model.pageController,
          itemCount: model.titlesList.length,
          onPageChanged: (index) {
            model.currentIndex = index;
          },
        ),
        // Only show the continue button if this is the last page
        Visibility(
          visible: model.isLastPage,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Directionality.of(context) == TextDirection.ltr
                    ? Alignment.bottomRight
                    : Alignment.bottomLeft,
                child: OutlinedButton(
                  // Set on boarding finished to true and redirect to auth.
                  onPressed: () =>
                      SharedPreferences.getInstance().then((instance) {
                    instance.setBool(FINISHED_ON_BOARDING, true);
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/auth', (_) => false);
                  }),
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
              controller: model.pageController,
              count: model.titlesList.length,
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
}
