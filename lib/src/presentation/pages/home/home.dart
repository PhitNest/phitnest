import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

class _StyledNavigationBarState extends State<StyledNavigationBar> {
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
        padding: EdgeInsets.only(bottom: 18.h),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavButton(context, 'News', () {}),
                NavButton(context, 'Explore', () {}),
                NavButton(context, 'Chat', () {}),
                NavButton(context, 'Options', () {}),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget NavButton(
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
