import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './widgets/favourite_icon_function.dart';
import './widgets/activity_post.dart';

import '../view.dart';

class NewsView extends ScreenView {
  final List<Map<String, dynamic>> dummyData;
  final Function? onPressedLiked;
  final int status;

  NewsView(
      {required this.onPressedLiked,
      required this.status,
      required this.dummyData})
      : super();

  @override
  int? get navbarIndex => 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          47.verticalSpace,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Planet Fitness',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Row(
                  children: [
                    Text(
                      '1.1k',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Color(0xff858585),
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    FavouriteIconFunction(
                      onPressedLiked: onPressedLiked,
                      status: 2,
                    )
                  ],
                ),
              ],
            ),
          ),
          40.verticalSpace,
          Container(
            height: 560,
            child: ListView.builder(
              itemCount: dummyData.length,
              itemBuilder: (context, index) {
                return ActivityPost(
                  title: dummyData[index]['title'],
                  subtitle: dummyData[index]['subtitle'],
                  status: dummyData[index]['status'],
                );
              },
            ),
          )
        ],
      )),
    );
  }
}
