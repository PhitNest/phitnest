import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 200.h, bottom: 51.h),
        child: Column(children: [
          SizedBox(
              width: 301.w,
              child: Text(
                'Welcome to the Nest.',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              )),
          40.verticalSpace,
          SizedBox(
              width: 205.w,
              child: Text(
                'This is the beginning of a beautiful friendship.',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(height: 1.56),
                textAlign: TextAlign.center,
              )),
          Expanded(child: Container()),
          Arrow(
            color: Theme.of(context).colorScheme.tertiary,
            width: 71.w,
            height: 10.h,
          )
        ]),
      );
}
