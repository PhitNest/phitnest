import 'package:device/device.dart';
import 'package:flutter/material.dart';

import 'package:phitnest/constants/constants.dart';

import '../models.dart';
import '../providers.dart';
import '../views.dart';
import 'pages/on_boarding_page.dart';

class OnBoardingProvider
    extends PreAuthenticationProvider<OnBoardingModel, OnBoardingView> {
  @override
  Future<bool> init(BuildContext context, OnBoardingModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }

    if (await deviceStorage.read(key: FINISHED_ON_BOARDING_SETTING) == 'true') {
      Navigator.pushNamed(context, '/auth');
      return false;
    } else {
      return true;
    }
  }

  @override
  OnBoardingView build(BuildContext context, OnBoardingModel model) =>
      OnBoardingView(
        pages: getPages(context).toList(),
      );

  static Iterable<OnBoardingPage> getPages(BuildContext context) sync* {
    for (int i = 0; i < OnBoardingModel.pages.length; i++) {
      OnBoardingPageData pageData = OnBoardingModel.pages[i];
      yield OnBoardingPage(
        path: pageData.path,
        text: pageData.text,
        pageNum: i,
        onClickContinue: () async {
          await deviceStorage.write(
              key: FINISHED_ON_BOARDING_SETTING, value: 'true');
          Navigator.pushNamed(context, '/auth');
        },
      );
    }
  }
}
