import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../theme.dart';
import '../../../../widgets/styled_outline_button.dart';

class FriendRequestScreen extends StatelessWidget {
  const FriendRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            64.verticalSpace,
            Text(
              'Friend requests',
              style: AppTheme.instance.theme.textTheme.bodyLarge,
            ),
            32.verticalSpace,
            SizedBox(
              // This height need to be changed dynamically depending on the
              // number of requests times the height of each request.
              height: 0.3.sh,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 2,
                itemBuilder: (context, i) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Heidi W.',
                      style: AppTheme.instance.theme.textTheme.bodyMedium,
                    ),
                    9.verticalSpace,
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                          ),
                          child: Text(
                            'ACCEPT',
                            style: AppTheme.instance.theme.textTheme.bodySmall,
                          ),
                        ),
                        16.horizontalSpace,
                        StyledOutlineButton(
                          hPadding: 17.w,
                          vPadding: 9.h,
                          onPress: () {},
                          text: 'IGNORE',
                        )
                      ],
                    ),
                    18.verticalSpace,
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Friends',
                  style: AppTheme.instance.theme.textTheme.bodyLarge,
                ),
                StyledOutlineButton(
                  onPress: () {},
                  text: 'EDIT',
                  hPadding: 16.w,
                  vPadding: 8.h,
                ),
              ],
            ),
            20.verticalSpace,
            SizedBox(
              // This has to be multiplied with the number of friends.
              height: 120.h,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 5,
                itemBuilder: (context, i) => Padding(
                  padding: EdgeInsets.all(8.h),
                  child: Text(
                    'Bobby W.',
                    style: AppTheme.instance.theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
