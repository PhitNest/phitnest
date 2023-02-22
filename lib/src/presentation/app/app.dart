library app;

import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/backend/backend.dart';
import '../../data/cache/cache.dart';
import '../../common/theme.dart';
import '../pages/pages.dart';
import '../widgets/widgets.dart';

part 'login_or_confirm_email_redirect.dart';
part 'redirect_to_home.dart';
part 'device_preview.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      // To use DevicePreview, add an entry to your .env file with the name of the device you want to use.
      // The available devices are listed in the example .env files.
      DevicePreviewProvider(
        builder: (context, usingDevicePreview) => ScreenUtilInit(
          minTextAdapt: true,
          // These dimensions come directly from the Figma design. This is meant to scale our UI to fit the design.
          designSize: const Size(375, 667),
          // We need to inherit media query if we are using DevicePreview.
          useInheritedMediaQuery: usingDevicePreview,
          builder: (context, child) => MaterialApp(
            scaffoldMessengerKey: StyledErrorBanner.scaffoldMessengerKey,
            title: 'PhitNest',
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (context) {
                // If there is user data and a password in the cache, then we know that the user has registered.
                final user = Cache.user.user;
                if (user != null && Cache.auth.password != null) {
                  // If the following data is in the cache, then we know that the user is logged in.
                  // This profile picture url is likely expired, but in case it isn't we can use it.
                  if (user.confirmed &&
                      Cache.auth.accessToken != null &&
                      Cache.auth.refreshToken != null &&
                      Cache.profilePicture.profilePictureUrl != null &&
                      Cache.gym.gym != null) {
                    return const _RedirectHome();
                  } else {
                    // The user is either not logged in or their account is not confirmed.
                    return const _LoginOrRedirectToConfirmEmail();
                  }
                }
                // The user has not registered, or they have signed out and restarted the app.
                return OnBoardingPage();
              },
            ),
          ),
        ),
      );
}
