import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../../../../entities/entities.dart';
import '../../../../widgets/widgets.dart';
import '../../home.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key}) : super();

  @override
  Widget build(BuildContext context) => UserConsumer(
        listener: (context, userState) {},
        builder: (context, userState) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              switch (userState) {
                LoaderLoadedState(data: final response) => switch (response) {
                    AuthRes(data: final response) => switch (response) {
                        HttpResponseSuccess(data: final response) => switch (
                              response) {
                            GetUserSuccess(
                              user: final user,
                              profilePicture: final pfp
                            ) =>
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  64.verticalSpace,
                                  Text(
                                    'Your Account',
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  32.verticalSpace,
                                  Text(
                                    '${user.firstName} ${user.lastName}',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  16.verticalSpace,
                                  Text(
                                    user.email,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  16.verticalSpace,
                                  Text(
                                    'TODO: POPULATE GYM ADDRESS',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  31.verticalSpace,
                                  pfp,
                                  32.verticalSpace,
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(),
                                    child: Text(
                                      'About Us',
                                      style:
                                          theme.textTheme.bodySmall!.copyWith(
                                        fontStyle: FontStyle.normal,
                                        decoration: TextDecoration.underline,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                      ),
                                    ),
                                  ),
                                  StyledOutlineButton(
                                    onPress: () {},
                                    text: 'Delete Account',
                                    hPadding: 16.w,
                                    vPadding: 8.h,
                                  ),
                                ],
                              ),
                            _ => const Loader(),
                          },
                        _ => const Loader(),
                      },
                    _ => const Loader(),
                  },
                _ => const Loader(),
              },
              StyledOutlineButton(
                onPress: () => context.logoutBloc
                    .add(LoaderLoadEvent(AuthReq(null, context.sessionLoader))),
                text: 'Sign Out',
                hPadding: 16.w,
                vPadding: 8.h,
              ),
            ],
          ),
        ),
      );
}
