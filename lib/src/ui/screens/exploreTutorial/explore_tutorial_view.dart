import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ExploreTutorialView extends ScreenView {
  final bool holding;
  final int countdown;

  ExploreTutorialView({
    required this.holding,
    required this.countdown,
  }) : super();

  @override
  int? get navbarIndex => 1;

  @override
  bool get navigationEnabled => false;

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  ],
                ),
              ),
      );
}
