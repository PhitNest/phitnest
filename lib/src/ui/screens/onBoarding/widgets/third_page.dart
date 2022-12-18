import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';
import '../../../widgets/widgets.dart';

class ThirdPage extends StatelessWidget {
  final Function() onPressedYes;

  const ThirdPage({
    required this.onPressedYes,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          200.verticalSpace,
          SizedBox(
            width: 301.w,
            child: Text(
              'Let\'s get started',
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          35.verticalSpace,
          SizedBox(
            width: 291.w,
            child: Text(
              'Do you belong to a fitness club?',
              style: theme.textTheme.labelLarge!.copyWith(height: 1.56),
              textAlign: TextAlign.center,
            ),
          ),
          35.verticalSpace,
          StyledButton(child: Text('YES'), onPressed: onPressedYes),
        ],
      );
}
