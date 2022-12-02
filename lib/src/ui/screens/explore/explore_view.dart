import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ExploreView extends NavBarScreenView {
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
  onTapDownLogo(BuildContext context) => onLogoTap(context);

  @override
  onTapUpLogo(BuildContext context) => onLogoRelease(context);

  @override
  int get navbarIndex => 1;

  @override
  bool get systemOverlayDark => false;

  @override
  bool get currentlyHoldingLogo => holding;

  @override
  Widget buildView(BuildContext context) => Column(
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
              Arrow(
                width: 40.w,
                height: 11.h,
                color: Colors.black,
                left: true,
              ),
              Text(
                'Erin-Michelle J.',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Arrow(
                width: 40.w,
                height: 11.h,
                color: Colors.black,
              ),
            ],
          ),
          80.verticalSpace,
          Text(
            'Press logo to send friend request',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
}
