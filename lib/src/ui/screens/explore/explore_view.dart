import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ExploreView extends ScreenView {
  const ExploreView() : super();

  @override
  int? get navbarIndex => 1;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Image.asset(
            'assets/images/selfie.png',
            width: 375.w,
            height: 333.h,
            fit: BoxFit.cover,
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
