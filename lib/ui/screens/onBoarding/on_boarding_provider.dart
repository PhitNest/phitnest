import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../providers.dart';
import 'on_boarding_model.dart';
import 'on_boarding_view.dart';

class OnBoardingProvider
    extends PreAuthenticationProvider<OnBoardingModel, OnBoardingView> {
  const OnBoardingProvider({Key? key}) : super(key: key);

  @override
  init(BuildContext context, OnBoardingModel model) async {
    if (await super.init(context, model)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(FINISHED_ON_BOARDING_SETTING) ?? false) {
        Navigator.pushNamedAndRemoveUntil(context, '/auth', ((_) => false));
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  @override
  OnBoardingView buildView(BuildContext context, OnBoardingModel model) =>
      OnBoardingView(
          image: model.image,
          title: model.title,
          subtitle: model.subtitle,
          pageController: model.pageController,
          numPages: model.numPages,
          isLastPage: model.isLastPage,
          onPageChange: (int newPage) => model.currentIndex = newPage,
          onClickContinue: () =>
              SharedPreferences.getInstance().then((instance) {
                instance.setBool(FINISHED_ON_BOARDING_SETTING, true);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/auth', (_) => false);
              }));
}
