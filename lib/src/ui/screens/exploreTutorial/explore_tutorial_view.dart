import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class ExploreTutorialView extends ScreenView {
  final bool holding;
  final int countdown;
  final VoidCallback onLogoTap;
  final VoidCallback onLogoRelease;

  const ExploreTutorialView({
    required this.holding,
    required this.countdown,
    required this.onLogoTap,
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
  Widget build(BuildContext context) => Scaffold(
        body: SizedBox(
          child: Column(
            children: [
              (holding ? 120 : 200).verticalSpace,
              holding
                  ? CountdownRing(
                      countdownNum: countdown,
                    )
                  : Text(
                      'Great!',
                      style: theme.textTheme.headlineLarge,
                    ),
              (holding ? 20 : 40).verticalSpace,
              holding
                  ? Text(
                      _countdownText,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: Color(0xFF707070),
                      ),
                    )
                  : Text(
                      'Let’s meet friends in your Nest',
                      style: theme.textTheme.labelLarge,
                    ),
              Expanded(child: Container()),
              holding
                  ? Container()
                  : Text(
                      'Press and hold logo to send friend request',
                      style: theme.textTheme.bodySmall,
                    ),
              20.verticalSpace,
              StyledNavBar(
                navigationEnabled: false,
                pageIndex: 1,
                animateLogo: !holding,
                colorful: true,
                onTapDownLogo: onLogoTap,
                onTapUpLogo: onLogoRelease,
              )
            ],
          ),
        ),
      );
}
