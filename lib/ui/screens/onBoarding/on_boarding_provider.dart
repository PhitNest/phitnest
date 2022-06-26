import 'package:device/device.dart';
import 'package:flutter/material.dart';
import 'package:phitnest/constants/constants.dart';

import '../screens.dart';
import 'on_boarding_model.dart';
import 'on_boarding_view.dart';
import 'pages/on_boarding_page.dart';

class OnBoardingProvider
    extends PreAuthenticationProvider<OnBoardingModel, OnBoardingView> {
  /// If this returns true, the loading widget is dropped. If it returns false,
  /// the loading widget stays until we navigate away from the screen.
  @override
  Future<bool> init(BuildContext context, OnBoardingModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }
    // Navigate away if we have already done on boarding. Otherwise, drop the
    // loading screen.
    if (await deviceStorage.read(key: kFinishedOnBoardingSetting) == 'true') {
      Navigator.pushNamedAndRemoveUntil(context, '/auth', (_) => false);
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

  /// Generate the on boarding pages
  static Iterable<OnBoardingPage> getPages(BuildContext context) sync* {
    for (int i = 0; i < OnBoardingModel.pages.length; i++) {
      OnBoardingPageData pageData = OnBoardingModel.pages[i];
      yield OnBoardingPage(
        path: pageData.path,
        text: pageData.text,
        pageNum: i,
        onClickContinue: () async {
          await deviceStorage.write(
              key: kFinishedOnBoardingSetting, value: 'true');
          Navigator.pushNamedAndRemoveUntil(context, '/auth', (_) => false);
        },
      );
    }
  }

  @override
  OnBoardingModel createModel() => OnBoardingModel();
}
