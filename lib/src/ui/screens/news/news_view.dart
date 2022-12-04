import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/activity_post.dart';
import 'widgets/like_button.dart';

import '../view.dart';
import 'models/activity_post.dart';

class NewsView extends ScreenView {
  final String title;
  final bool liked;
  final List<ActivityPostModel> posts;
  final String likeCount;
  final Function() onPressedLike;
  final Function(int index) onPressedLikePost;

  const NewsView({
    required this.title,
    required this.likeCount,
    required this.liked,
    required this.onPressedLike,
    required this.posts,
    required this.onPressedLikePost,
  }) : super();

  @override
  int get navbarIndex => 0;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          80.verticalSpace,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Row(
                  children: [
                    Text(
                      likeCount,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Color(0xff858585),
                          fontWeight: FontWeight.w600),
                    ),
                    LikeButton(
                      liked: liked,
                      onPressedLiked: onPressedLike,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 470.h,
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ActivityPost(
                    model: posts[index],
                    onPressedLike: () => onPressedLikePost(index));
              },
            ),
          )
        ],
      );
}
