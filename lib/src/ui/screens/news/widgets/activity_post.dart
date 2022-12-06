import 'package:flutter/material.dart';

import '../../../theme.dart';
import '../models/activity_post.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityPost extends StatelessWidget {
  final ActivityPostModel model;
  final VoidCallback onPressedLike;

  const ActivityPost({
    required this.model,
    required this.onPressedLike,
  }) : super();

  @override
  Widget build(BuildContext context) => Container(
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
                  Expanded(
                    child: Text(
                      model.subtitle,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium!
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  model.liked != null
                      ? InkWell(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: onPressedLike,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 9),
                              child: Container(
                                  width: 23.w,
                                  height: 20.h,
                                  child: Image.asset(
                                    model.liked!
                                        ? 'assets/images/favourite_icon_red.png'
                                        : 'assets/images/favourite_icon_white.png',
                                    fit: BoxFit.contain,
                                  ))),
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
