import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view.dart';

class ChatView extends NavBarScreenView {
  final Color onClickColor;
  final Function() onClickMessage;
  final Function() onClickFriends;

  ChatView({
    required this.onClickColor,
    required this.onClickMessage,
    required this.onClickFriends,
  });

  @override
  int get navbarIndex => 2;

  @override
  Widget buildView(BuildContext context) => Column(
        children: [
          73.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onClickFriends,
                child: Text(
                  'FRIENDS',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
              ),
              32.horizontalSpace,
            ],
          ),
          GestureDetector(
            onTap: onClickMessage,
            child: Container(
              width: 343.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: onClickColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priscilla H.',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontSize: 18.sp),
                    ),
                    8.44.verticalSpace,
                    Text(
                      'I’m an occupational therapist... I can help you with that!',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
