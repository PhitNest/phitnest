import 'package:flutter/material.dart';

import './favourite_icon_function.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityPost extends StatelessWidget {
  final String title;
  final String subtitle;
  final int status;

  const ActivityPost(
      {required this.title, required this.subtitle, required this.status})
      : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Color(0xff858585), fontWeight: FontWeight.w400),
            ),
          ),
          8.verticalSpace,
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 254,
                  child: Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                FavouriteIconFunction(
                  onPressedLiked: () {},
                  status: status,
                ),
              ],
            ),
          ),
          40.verticalSpace
        ],
      ),
    );
  }
}
