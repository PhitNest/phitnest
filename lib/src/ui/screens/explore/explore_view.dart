import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/widgets.dart';
import '../view.dart';

class ExploreView extends ScreenView {
  final bool holding;
  final int countdown;
  final Function(BuildContext context) onLogoTap;
  final Function(BuildContext context) onLogoRelease;

  ExploreView({
    required this.holding,
    required this.countdown,
    required this.onLogoTap,
    required this.onLogoRelease,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            SizedBox(
              width: 375.w,
              height: 333.h,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/selfie.png',
                    fit: BoxFit.cover,
                  ),
                  holding
                      ? Center(
                          child: CountdownRing(
                            countdownNum: countdown,
                            dark: false,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            120.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  'assets/images/left_arrow.png',
                  width: 40.w,
                ),
                Text(
                  'Erin-Michelle J.',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Image.asset(
                  'assets/images/right_arrow.png',
                  width: 40.w,
                ),
              ],
            ),
            80.verticalSpace,
            Text(
              'Press logo to send friend request',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
}
