import 'package:device/storage/storage.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../providers.dart';
import 'on_boarding_model.dart';
import 'on_boarding_view.dart';

class OnBoardingProvider
    extends PreAuthenticationProvider<OnBoardingModel, OnBoardingView> {
  OnBoardingProvider() : super(key: Key("provider_onboarding"));

  @override
  init(BuildContext context, OnBoardingModel model) async {
    if (!await super.init(context, model)) return false;

    if (await deviceStorage.read(key: FINISHED_ON_BOARDING_SETTING) == 'true') {
      Navigator.pushNamedAndRemoveUntil(context, '/auth', ((_) => false));
      return false;
    } else {
      return true;
    }
  }

  @override
  OnBoardingView build(BuildContext context, OnBoardingModel model) =>
      OnBoardingView(
          image: model.image,
          title: model.title,
          subtitle: model.subtitle,
          pageController: model.pageController,
          numPages: model.numPages,
          isLastPage: model.isLastPage,
          onPageChange: (int newPage) => model.currentIndex = newPage,
          onClickContinue: () => deviceStorage
              .write(key: FINISHED_ON_BOARDING_SETTING, value: 'true')
              .then((_) => Navigator.pushNamedAndRemoveUntil(
                  context, '/auth', (_) => false)));
}
