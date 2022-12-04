import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';
import '../../../widgets/widgets.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          200.verticalSpace,
          SizedBox(
            width: 301.w,
            child: Text(
              'Welcome to the Nest.',
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          35.verticalSpace,
          SizedBox(
            width: 205.w,
            child: Text(
              'This is the beginning of a beautiful friendship.',
              style: theme.textTheme.labelLarge!.copyWith(height: 1.56),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: Container()),
          RedArrowWidget(),
          51.verticalSpace,
        ],
      );
}
