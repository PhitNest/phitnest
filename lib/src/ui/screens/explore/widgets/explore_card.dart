import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';
import '../../../widgets/widgets.dart';

class ExploreCard extends StatelessWidget {
  final String fullName;
  final int? countdown;

  const ExploreCard({
    Key? key,
    required this.fullName,
    required this.countdown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 375.w,
                height: 333.h,
                child: Image.asset(
                  'assets/images/selfie.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 40.h),
                alignment: Alignment.topCenter,
                child: countdown != null
                    ? CountdownRing(
                        countdownNum: countdown!,
                        dark: false,
                      )
                    : null,
              ),
            ],
          ),
          80.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SizedBox(
              height: 120.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'assets/images/left_arrow.png',
                    width: 40.w,
                  ),
                  Container(
                    width: 240.w,
                    child: Text(
                      fullName,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineLarge,
                      softWrap: true,
                    ),
                  ),
                  Image.asset(
                    'assets/images/right_arrow.png',
                    width: 40.w,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
