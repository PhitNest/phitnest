import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets.dart';
import '../../view.dart';

class CountdownView extends ScreenView {
  final int countdownCounter;

  CountdownView({
    Key? key,
    this.countdownCounter = 3,
  }) : super();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            144.verticalSpace,
            CountdownRing(
              countdownNum: countdownCounter,
            ),
            149.verticalSpace,
            Text(
              countdownCounter == 3
                  ? 'Keep Holding...'
                  : countdownCounter == 2
                      ? 'Almost there...'
                      : 'Have fun :)',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Color(0xFF707070)),
            ),
          ],
        ),
      );
}
