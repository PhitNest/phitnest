import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/assets_constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home Page'),
      ),
      bottomNavigationBar: StyledNavigationBar(),
    );
  }
}

class StyledNavigationBar extends StatefulWidget {
  const StyledNavigationBar({Key? key}) : super(key: key);

  @override
  State<StyledNavigationBar> createState() => _StyledNavigationBarState();
}

class _StyledNavigationBarState extends State<StyledNavigationBar>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController!);
    _animationController!.repeat(period: Duration(seconds: 1));
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  Widget logoButton(
    VoidCallback onTapDownLogo,
    VoidCallback onReleaseLogo,
  ) =>
      GestureDetector(
        onTapCancel: onReleaseLogo,
        onTapDown: (_) => onTapDownLogo,
        child: AnimatedContainer(
          duration: Duration(seconds: 2),
          width: _animation!.value * 550,
          height: _animation!.value * 550,
          child: Image.asset(
            kLogoPath,
            width: 38.62.w,
          ),
        ),
      );

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
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  width: _animation!.value * 550,
                  height: _animation!.value * 550,
                  child: Image.asset(
                    kLogoPath,
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
