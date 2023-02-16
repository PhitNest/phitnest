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
import '../../domain/entities/entities.dart';
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
          // TODO: Figure out what minTextAdapt is
          minTextAdapt: true,
          // These dimensions come directly from the Figma design. This is meant to scale our UI to fit the design.
          designSize: const Size(375, 667),
          // We need to inherit media query if we are using DevicePreview.
          useInheritedMediaQuery: usingDevicePreview,
          builder: (context, child) => MaterialApp(
            title: 'PhitNest',
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (context) {
                // If there is user data and a password in the cache, then we know that the user has registered.
                final user = Cache.user;
                final password = Cache.password;
                if (user != null && password != null) {
                  // If the following data is in the cache, then we know that the user is logged in.
                  // This profile picture url is likely expired, but in case it isn't we can use it.
                  final profilePictureUrl = Cache.profilePictureUrl;
                  final accessToken = Cache.accessToken;
                  final refreshToken = Cache.refreshToken;
                  final gym = Cache.gym;
                  if (user.confirmed &&
                      accessToken != null &&
                      refreshToken != null &&
                      profilePictureUrl != null &&
                      gym != null) {
                    return _RedirectHome(
                      accessToken: accessToken,
                      refreshToken: refreshToken,
                      gym: gym,
                      user: user,
                      profilePictureUrl: profilePictureUrl,
                      password: password,
                    );
                  } else {
                    // The user is either not logged in or their account is not confirmed.
                    return _LoginOrRedirectToConfirmEmail(
                      shouldRedirect: !user.confirmed,
                      email: user.email,
                      password: password,
                    );
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
