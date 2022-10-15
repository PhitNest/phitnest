import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../view.dart';

class IntroView extends ScreenView {
  @override
  Widget build(BuildContext context) => SizedBox(
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
      );
}
