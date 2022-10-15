import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ExploreTutorialView extends ScreenView {
  final Function(TapDownDetails? details) onTapDownLogo;
  final Function(TapUpDetails? details) onTapUpLogo;
  final bool holding;
  final int countdown;

  ExploreTutorialView({
    required this.onTapDownLogo,
    required this.onTapUpLogo,
    required this.holding,
    required this.countdown,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: holding
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    144.verticalSpace,
                    CountdownRing(
                      countdownNum: countdown,
                    ),
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
                          .copyWith(color: Color(0xFF707070)),
                    ),
                  ],
                ))
            : SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    156.verticalSpace,
                    Text(
                      'Great!',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    40.verticalSpace,
                    Text(
                      'Let’s meet friends in your Nest',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: StyledNavBar(
          pageIndex: 1,
          onTapDownLogo: onTapDownLogo,
          onTapUpLogo: onTapUpLogo,
        ),
      );
}
