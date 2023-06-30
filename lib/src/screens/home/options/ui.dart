import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import '../../../common/util.dart';
import '../../../theme.dart';
import '../../../widgets/styled_outline_button.dart';
import '../../about_us/ui.dart';
import '../bloc/bloc.dart';

class OptionsScreen extends StatelessWidget {
  final Image pfp;

  const OptionsScreen({
    super.key,
    required this.pfp,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              64.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Account',
                    style: AppTheme.instance.theme.textTheme.bodyLarge,
                  ),
                  StyledOutlineButton(
                    onPress: () {},
                    text: 'EDIT',
                    hPadding: 16.w,
                    vPadding: 8.h,
                  ),
                ],
              ),
              32.verticalSpace,
              Text(
                'Erin-Michelle Jimenez',
                style: AppTheme.instance.theme.textTheme.bodyMedium,
              ),
              16.verticalSpace,
              Text(
                'erin@gmail.com',
                style: AppTheme.instance.theme.textTheme.bodyMedium,
              ),
              16.verticalSpace,
              Text(
                'Planet Fitness\n'
                '1234 Main Street\n'
                'City, VA 22030',
                style: AppTheme.instance.theme.textTheme.bodyMedium,
              ),
              31.verticalSpace,
              pfp,
              32.verticalSpace,
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                    builder: (context) => const AboutUsScreen(),
                  ),
                ),
                style: TextButton.styleFrom(),
                child: Text(
                  'About Us',
                  style: AppTheme.instance.theme.textTheme.bodySmall!.copyWith(
                    fontStyle: FontStyle.normal,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                ),
              ),
              StyledOutlineButton(
                onPress: () => context.homeBloc.add(
                  const HomeDeleteAccountEvent(),
                ),
                text: 'Delete Account',
                hPadding: 16.w,
                vPadding: 8.h,
              ),
              StyledOutlineButton(
                onPress: () =>
                    context.cognitoBloc.add(const CognitoLogoutEvent()),
                text: 'Sign Out',
                hPadding: 16.w,
                vPadding: 8.h,
              ),
            ],
          ),
        ),
      );
}
