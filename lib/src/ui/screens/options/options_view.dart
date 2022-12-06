import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_mobile/src/ui/widgets/bottom_nav_bar.dart';

import '../view.dart';

class OptionsView extends ScreenView {
  final VoidCallback onPressedLogo;

  const OptionsView({
    required this.onPressedLogo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Image.asset(
              'assets/images/phitnestSelfie.png',
              height: 280.h,
              width: 1.sw,
              fit: BoxFit.cover,
            ),
            40.verticalSpace,
            Text(
              'Eric-Michelle Jimenez',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            32.verticalSpace,
            Text(
              'erin@google.com',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Divider(
              thickness: 1,
              indent: 32.w,
              endIndent: 32.w,
            ),
            24.verticalSpace,
            Text(
              'Planet Fitness, Falls Church, VA',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Divider(
              thickness: 1,
              indent: 32.w,
              endIndent: 32.w,
            ),
            Expanded(child: Container()),
            StyledNavBar(
              navigationEnabled: true,
              pageIndex: 3,
              onTapDownLogo: onPressedLogo,
            ),
          ],
        ),
      );
}
