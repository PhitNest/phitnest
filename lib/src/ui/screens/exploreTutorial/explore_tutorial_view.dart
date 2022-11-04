import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ExploreTutorialView extends NavBarScreenView {
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

  @override
  Widget buildView(BuildContext context) => Scaffold(
        body: holding
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    144.verticalSpace,
                    CountdownRing(countdownNum: countdown),
                    149.verticalSpace,
                    Text(
                        countdown == 3
                            ? 'Keep Holding...'
                            : countdown == 2
                                ? 'Almost there...'
                                : 'Have fun :)',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Color(0xFF707070))),
                  ],
                ))
            : SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    186.verticalSpace,
                    Text(
                      'Great!',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    40.verticalSpace,
                    Text(
                      'Let’s meet friends in your Nest',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text('Hold the button below to complete the tutorial'),
                    32.verticalSpace,
                  ],
                ),
              ),
      );
}
