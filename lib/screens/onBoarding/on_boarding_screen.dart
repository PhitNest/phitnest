import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:phitnest/constants/constants.dart';
import 'package:phitnest/helpers/helpers.dart';
import 'package:phitnest/screens/screens.dart';
import 'package:phitnest/models/models.dart';

/// This is a slide show shown on the first use of the app.
class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  ///list of strings containing onBoarding titles
  static const List<String> _titlesList = [
    'Get a Date',
    'Private Messages',
    'Send Photos',
    'Get Notified'
  ];

  /// list of strings containing onBoarding subtitles, the small text under the
  /// title
  static const List<String> _subtitlesList = [
    'Swipe right to get a match with people you like from your area.',
    'Chat privately with people you match.',
    'Have fun with your matches by sending photos and videos to each other.',
    'Receive notifications when you get new messages and matches.'
  ];

  /// list containing image paths or IconData representing the image of each page
  static const List<dynamic> _imageList = [
    'assets/images/app_logo.png',
    Icons.chat_bubble_outline,
    Icons.photo_camera,
    Icons.notifications_none
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(COLOR_PRIMARY),
        // Provide a change notifier for this model down the widget tree
        body: ChangeNotifierProvider(
            create: (context) => OnBoardingModel(),
            builder: (context, child) => Consumer<OnBoardingModel>(
                  // Build a stack on each change notification
                  builder: (context, model, child) => Stack(
                    children: <Widget>[
                      PageView.builder(
                        itemBuilder: (context, index) => getPage(index),
                        controller: model.pageController,
                        itemCount: _titlesList.length,
                        onPageChanged: (int index) =>
                            // Update the current page
                            model.currentIndex = index,
                      ),
                      Visibility(
                        // If this is the final page, show the continue button
                        visible: model.currentIndex + 1 == _titlesList.length,
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Directionality.of(context) ==
                                      TextDirection.ltr
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft,
                              child: OutlinedButton(
                                onPressed: () {
                                  // Upon pressing continue, finish on boarding
                                  setFinishedOnBoarding();
                                  // Continue to the authentication screen
                                  NavigationUtils.pushReplacement(
                                      context, AuthScreen());
                                },
                                child: Text(
                                  'Continue'.tr(),
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
                            count: _titlesList.length,
                            effect: ScrollingDotsEffect(
                                activeDotColor: Colors.white,
                                dotColor: Colors.grey.shade400,
                                dotWidth: 8,
                                dotHeight: 8,
                                fixedCenter: true),
                          ),
                        ),
                      )
                    ],
                  ),
                )));
  }

  /// Get the proper page given page index.
  Widget getPage(int index) {
    dynamic image = _imageList[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        image is String
            ? Image.asset(
                image,
                color: Colors.white,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
            : Icon(
                image as IconData,
                color: Colors.white,
                size: 150,
              ),
        SizedBox(height: 40),
        Text(
          _titlesList[index].tr().toUpperCase(),
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _subtitlesList[index].tr(),
            style: TextStyle(color: Colors.white, fontSize: 14.0),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// Set the on boarding finished preference in device preferences for future
  /// reference.
  Future<bool> setFinishedOnBoarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(FINISHED_ON_BOARDING, true);
  }
}
