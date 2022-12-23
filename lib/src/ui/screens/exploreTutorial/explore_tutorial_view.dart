import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';

class InitialView extends StatelessWidget {
  final VoidCallback onPressLogo;
  final GlobalKey navbarKey;

  const InitialView({
    required this.navbarKey,
    required this.onPressLogo,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: Column(
          children: [
            200.verticalSpace,
            Text(
              'Great!',
              style: theme.textTheme.headlineLarge,
            ),
            40.verticalSpace,
            Text(
              'Let’s meet friends in your Nest',
              style: theme.textTheme.labelLarge,
            ),
            Spacer(),
            Text(
              'Press and hold logo to send friend request',
              style: theme.textTheme.bodySmall,
            ),
            20.verticalSpace,
            StyledNavBar(
              gestureKey: navbarKey,
              navigationEnabled: false,
              page: NavbarPage.explore,
              animateLogo: true,
              colorful: true,
              onPressDownLogo: onPressLogo,
            )
          ],
        ),
      );
}

class HoldingView extends StatelessWidget {
  final int countdown;
  final VoidCallback onLogoRelease;
  final GlobalKey navbarKey;

  const HoldingView({
    required this.navbarKey,
    required this.countdown,
    required this.onLogoRelease,
  }) : super();

  String get _countdownText {
    switch (countdown) {
      case 3:
        return 'Keep Holding...';
      case 2:
        return 'Almost there...';
      default:
        return 'Have fun :)';
    }
  }

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: Column(
          children: [
            120.verticalSpace,
            CountdownRing(
              countdownNum: max(countdown, 1),
            ),
            20.verticalSpace,
            Text(
              _countdownText,
              style: theme.textTheme.bodySmall!.copyWith(
                color: Color(0xFF707070),
              ),
            ),
            Spacer(),
            StyledNavBar(
              gestureKey: navbarKey,
              navigationEnabled: false,
              page: NavbarPage.explore,
              colorful: true,
              onReleaseLogo: onLogoRelease,
            )
          ],
        ),
      );
}
