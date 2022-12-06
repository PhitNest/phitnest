import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_mobile/src/ui/widgets/bottom_nav_bar.dart';
import '../../theme.dart';
import 'widgets/activity_post.dart';

import '../view.dart';
import 'models/activity_post.dart';

class NewsView extends ScreenView {
  final String title;
  final List<ActivityPostModel> posts;
  final void Function(int index) onPressedLike;
  final VoidCallback onPressedLogo;

  const NewsView({
    required this.title,
    required this.onPressedLike,
    required this.posts,
    required this.onPressedLogo,
  }) : super();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Column(
            children: [
              60.verticalSpace,
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 32.w),
                child: Text(
                  title,
                  style: theme.textTheme.headlineLarge,
                ),
              ),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.white,
                      Colors.white,
                      Colors.white.withOpacity(0.05)
                    ],
                    stops: [0, 0.02, 0.95, 1],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds),
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) => ActivityPost(
                      model: posts[index],
                      onPressedLike: () => onPressedLike(index),
                    ),
                  ),
                ),
              ),
              StyledNavBar(
                navigationEnabled: true,
                pageIndex: 0,
                onTapDownLogo: onPressedLogo,
              ),
            ],
          ),
        ),
      );
}
