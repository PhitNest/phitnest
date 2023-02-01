import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/backend/backend.dart';
import '../data/cache/cache.dart';
import '../common/theme.dart';
import 'pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(375, 667),
        builder: (context, child) => MaterialApp(
          title: 'PhitNest',
          theme: theme,
          debugShowCheckedModeBanner: false,
          home: Builder(
            builder: (context) {
              final user = cachedUser;
              final password = cachedPassword;
              if (user != null && password != null) {
                final accessToken = cachedAccessToken;
                final refreshToken = cachedRefreshToken;
                if (user.confirmed &&
                    accessToken != null &&
                    refreshToken != null) {
                  return HomePage(
                    initialAccessToken: accessToken,
                    initialRefreshToken: refreshToken,
                    initialUserData: user,
                    initialPassword: password,
                  );
                } else {
                  Future.delayed(
                    Duration.zero,
                    () => Navigator.of(context)
                      ..pushReplacement(
                        CupertinoPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      )
                      ..push<LoginResponse>(
                        CupertinoPageRoute(
                          builder: (context) => ConfirmEmailPage(
                            password: password,
                            email: user.email,
                          ),
                        ),
                      ).then(
                        (response) => response != null
                            ? Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => HomePage(
                                    initialAccessToken: response.accessToken,
                                    initialRefreshToken: response.refreshToken,
                                    initialUserData: response.user,
                                    initialPassword: password,
                                  ),
                                ),
                                (_) => false,
                              )
                            : null,
                      ),
                  );
                  return LoginPage();
                }
              }
              return OnBoardingPage();
            },
          ),
        ),
      );
}
