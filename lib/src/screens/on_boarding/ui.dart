import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../login/ui.dart';
import '../register/ui.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              120.verticalSpace,
              Text(
                'It takes a village to live a healthy life',
                style: AppTheme.instance.theme.textTheme.bodyLarge,
              ),
              32.verticalSpace,
              Text(
                'Meet people at your fitness club.\nArchive your goals together.'
                '\nLive a healthy life',
                style: AppTheme.instance.theme.textTheme.bodyMedium,
              ),
              // 206.verticalSpace,
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (context) => const RegisterScreen(),
                    ),
                  ),
                  child: Text(
                    "LET'S GET STARTED",
                    style: AppTheme.instance.theme.textTheme.bodySmall,
                  ),
                ),
              ),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (context) => const LoginScreen(),
                    ),
                  ),
                  child: Text(
                    'I already have an account',
                    style:
                        AppTheme.instance.theme.textTheme.bodySmall!.copyWith(
                      decoration: TextDecoration.underline,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              100.verticalSpace,
            ],
          ),
        ),
      );
}
