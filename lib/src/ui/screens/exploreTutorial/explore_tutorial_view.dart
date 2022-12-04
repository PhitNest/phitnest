import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/widgets.dart';
import '../view.dart';

class ExploreTutorialView extends ScreenView {
  final bool holding;
  final int countdown;
  final Function(BuildContext context) onLogoTap;
  final Function(BuildContext context) onLogoRelease;

  ExploreTutorialView({
    required this.holding,
    required this.countdown,
    required this.onLogoTap,
    required this.onLogoRelease,
  }) : super();

  @override
  onTapDownLogo(BuildContext context) => onLogoTap(context);

  @override
  onTapUpLogo(BuildContext context) => onLogoRelease(context);

  @override
  int get navbarIndex => 1;

  @override
  bool get navigationEnabled => false;

  @override
  bool get currentlyHoldingLogo => holding;

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
  Widget build(BuildContext context) => SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          (holding ? 144 : 186).verticalSpace,
          holding
              ? CountdownRing(countdownNum: countdown)
              : Text(
                  'Great!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
          (holding ? 149 : 40).verticalSpace,
          holding
              ? Text(_countdownText,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Color(0xFF707070)))
              : Text(
                  'Let’s meet friends in your Nest',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
        ],
      ));
}
