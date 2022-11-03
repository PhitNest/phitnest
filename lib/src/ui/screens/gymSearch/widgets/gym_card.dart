import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/models.dart';
import '../../../../utils/utils.dart';

class GymCard extends StatelessWidget {
  final bool selected;
  final Gym gym;
  final double distance;
  final Function() onPressed;

  GymCard(
      {required this.onPressed,
      required this.selected,
      required this.gym,
      required this.distance})
      : super();

  @override
  build(BuildContext context) => Container(
      width: 343.w,
      child: OutlinedButton(
          style: ButtonStyle(
              side: MaterialStateProperty.all(
                  BorderSide(color: Colors.transparent)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )),
              backgroundColor: MaterialStateProperty.all(
                  selected ? Color(0xFFFFE3E3) : Colors.transparent)),
          onPressed: onPressed,
          child: Container(
              width: 1.sw,
              margin: EdgeInsets.symmetric(vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${gym.name} (${distance.formatQuantity("mile")})',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(
                      width: 250.w,
                      child: Text(gym.address.toString(),
                          style: Theme.of(context).textTheme.labelMedium))
                ],
              ))));
}