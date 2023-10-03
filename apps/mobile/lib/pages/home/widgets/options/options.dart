import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../../../../entities/entities.dart';
import '../../../../widgets/widgets.dart';
import '../../../about_us/about_us.dart';
import '../../home.dart';

class OptionsPage extends StatelessWidget {
  final User user;
  final Image profilePicture;
  final Gym gym;

  const OptionsPage({
    super.key,
    required this.user,
    required this.profilePicture,
    required this.gym,
  }) : super();

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                64.verticalSpace,
                Text(
                  'Your Account',
                  style: theme.textTheme.bodyLarge,
                ),
                32.verticalSpace,
                Text(
                  user.fullName,
                  style: theme.textTheme.bodyMedium,
                ),
                16.verticalSpace,
                Text(
                  user.email,
                  style: theme.textTheme.bodyMedium,
                ),
                16.verticalSpace,
                Text(
                  gym.toString(),
                  style: theme.textTheme.bodyMedium,
                ),
                31.verticalSpace,
                profilePicture,
                32.verticalSpace,
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute<void>(
                      builder: (_) => const AboutUsScreen(),
                    ),
                  ),
                  style: TextButton.styleFrom(),
                  child: Text(
                    'About Us',
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontStyle: FontStyle.normal,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
                StyledOutlineButton(
                  onPress: () => context.deleteUserBloc
                      .add(LoaderLoadEvent(AuthReq(null, context.sessionLoader))),
                  text: 'Delete Account',
                  hPadding: 16.w,
                  vPadding: 8.h,
                ),
                StyledOutlineButton(
                  onPress: () =>
                      context.logoutBloc.add(LoaderLoadEvent(AuthReq(null, context.sessionLoader))),
                  text: 'Sign Out',
                  hPadding: 16.w,
                  vPadding: 8.h,
                ),
              ],
            ),
          ),
        ),
      );
}
