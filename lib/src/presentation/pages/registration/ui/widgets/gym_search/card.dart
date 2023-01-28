import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/theme.dart';
import '../../../../../../common/utils/utils.dart';
import '../../../../../../domain/entities/entities.dart';

class GymCard extends StatelessWidget {
  final bool selected;
  final GymEntity gym;
  final double distance;
  final VoidCallback onPressed;

  GymCard({
    required this.onPressed,
    required this.selected,
    required this.gym,
    required this.distance,
  }) : super();

  @override
  build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(
              BorderSide(
                color: Colors.transparent,
              ),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
              selected ? Color(0xFFFFE3E3) : Colors.grey.shade50,
            ),
          ),
          onPressed: onPressed,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${gym.name} (${distance.formatUnits("mile")})',
                  style: theme.textTheme.labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 250.w,
                  child: Text(
                    gym.address.toString(),
                    style: theme.textTheme.labelMedium,
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
