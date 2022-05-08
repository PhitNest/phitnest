import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../providers.dart';
import 'on_boarding_model.dart';
import 'on_boarding_view.dart';

class OnBoardingProvider
    extends PreAuthenticationProvider<OnBoardingModel, OnBoardingView> {
  OnBoardingProvider({Key? key}) : super(key: key);

  @override
  init(BuildContext context, OnBoardingModel model) async {
    if (!await super.init(context, model)) return false;

    if ((await SharedPreferences.getInstance())
            .getBool(FINISHED_ON_BOARDING_SETTING) ??
        false) {
      Navigator.pushNamedAndRemoveUntil(context, '/auth', ((_) => false));
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget buildLoading(BuildContext context, String? text) =>
      super.buildLoading(context, 'Device Data');

  @override
  OnBoardingView build(BuildContext context) => OnBoardingView(
      image: model.image,
      title: model.title,
      subtitle: model.subtitle,
      pageController: model.pageController,
      numPages: model.numPages,
      isLastPage: model.isLastPage,
      onPageChange: (int newPage) => model.currentIndex = newPage,
      onClickContinue: () => SharedPreferences.getInstance().then((instance) {
            instance.setBool(FINISHED_ON_BOARDING_SETTING, true);
            Navigator.pushNamedAndRemoveUntil(context, '/auth', (_) => false);
          }));
}
