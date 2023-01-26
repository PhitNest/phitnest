import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants/assets.dart';

class StyledNavigationBar extends StatefulWidget {
  const StyledNavigationBar({Key? key}) : super(key: key);

  @override
  State<StyledNavigationBar> createState() => _StyledNavigationBarState();
}

class _StyledNavigationBarState extends State<StyledNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  Widget navButton(
    BuildContext context,
    String tabName,
    VoidCallback onPressed,
  ) =>
      TextButton(
        style: ButtonStyle(
          maximumSize: MaterialStateProperty.all(
            Size.fromWidth(78.w),
          ),
          minimumSize: MaterialStateProperty.all(
            Size.fromWidth(78.w),
          ),
          overlayColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          tabName,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
      );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    )..repeat(
        reverse: true,
        min: 0.55,
        max: 1,
      );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 66.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8.5,
            spreadRadius: 0.0,
            color: Colors.black,
            offset: Offset(0, 7),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(),
        child: Stack(
          children: [
            ScaleTransition(
              scale: _animation,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Image.asset(
                    Assets.logo.path,
                    width: 38.62.w,
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                navButton(context, 'News', () {}),
                navButton(context, 'Explore', () {}),
                60.horizontalSpace,
                navButton(context, 'Chat', () {}),
                navButton(context, 'Options', () {}),
              ],
            )
          ],
        ),
      ),
    );
  }
}
