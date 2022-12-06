import 'package:flutter/material.dart';

import '../../../theme.dart';
import '../models/activity_post.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'like_button.dart';

class ActivityPost extends StatelessWidget {
  final ActivityPostModel model;
  final Function() onPressedLike;

  const ActivityPost({required this.model, required this.onPressedLike})
      : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(
              model.title,
              style: theme.textTheme.bodySmall!.copyWith(
                  color: Color(0xff858585), fontWeight: FontWeight.w400),
            ),
          ),
          8.verticalSpace,
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 254.w,
                  child: Text(
                    model.subtitle,
                    style: theme.textTheme.labelMedium!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                model.liked != null
                    ? LikeButton(
                        onPressedLiked: onPressedLike,
                        liked: model.liked!,
                      )
                    : Container()
              ],
            ),
          ),
          40.verticalSpace
        ],
      ),
    );
  }
}
