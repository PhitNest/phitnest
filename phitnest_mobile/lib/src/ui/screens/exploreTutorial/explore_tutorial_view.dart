import 'package:flutter/material.dart';

import '../../common/widgets.dart';
import '../view.dart';
import 'countdown/countdown_provider.dart';
import 'intro/intro_provider.dart';

class ExploreTutorialView extends ScreenView {
  final int navIndex;
  final Function() onLongPressLogo;
  final int screenIndex;

  ExploreTutorialView({
    required this.navIndex,
    required this.onLongPressLogo,
    required this.screenIndex,
  }) : super();

  final tutorialPages = <Widget>[
    IntroProvider(),
    CountdownProvider(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: tutorialPages[screenIndex],
        bottomNavigationBar: StyledNavBar(
          pageIndex: navIndex,
          longPressLogo: onLongPressLogo,
        ),
      );
}
