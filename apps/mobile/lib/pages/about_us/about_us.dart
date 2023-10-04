import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

final class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 32.sp,
            ),
          ),
          title: Text(
            'About US',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              32.verticalSpace,
              TextButton(
                onPressed: () => {},
                style: TextButton.styleFrom(),
                child: Text(
                  'Terms of Service',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontStyle: FontStyle.normal,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                ),
              ),
              8.verticalSpace,
              TextButton(
                onPressed: () => {},
                style: TextButton.styleFrom(),
                child: Text(
                  'Privacy Policy',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontStyle: FontStyle.normal,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                ),
              ),
              8.verticalSpace,
              TextButton(
                onPressed: () => {},
                style: TextButton.styleFrom(),
                child: Text(
                  'Software Licenses',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontStyle: FontStyle.normal,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
