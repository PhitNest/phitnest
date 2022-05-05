import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../services/authentication_service.dart';
import '../../../constants/constants.dart';
import '../../../locator.dart';
import '../base_view.dart';
import 'widgets/on_boarding_page.dart';
import 'model/on_boarding_model.dart';

class OnBoardingView extends BaseView<OnBoardingModel> {
  @override
  init(BuildContext context, OnBoardingModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(FINISHED_ON_BOARDING) ?? false) {
      Navigator.pushNamedAndRemoveUntil(
          context,
          await locator<AuthenticationService>().isAuthenticated()
              ? '/home'
              : '/auth',
          ((_) => false));
    } else {
      model.loading = false;
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
        Visibility(
          visible: model.isLastPage,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Directionality.of(context) == TextDirection.ltr
                    ? Alignment.bottomRight
                    : Alignment.bottomLeft,
                child: OutlinedButton(
                  onPressed: () async {
                    (await SharedPreferences.getInstance())
                        .setBool(FINISHED_ON_BOARDING, true);
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/auth', (_) => false);
                  },
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
