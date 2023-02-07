import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/backend/backend.dart';
import '../data/cache/cache.dart';
import '../common/theme.dart';
import '../domain/entities/entities.dart';
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
              final user = Cache.user;
              final password = Cache.password;
              if (user != null && password != null) {
                final accessToken = Cache.accessToken;
                final refreshToken = Cache.refreshToken;
                final profilePictureUrl = Cache.profilePictureUrl;
                final gym = Cache.gym;
                if (user.confirmed &&
                    accessToken != null &&
                    refreshToken != null &&
                    profilePictureUrl != null &&
                    gym != null) {
                  return HomePage(
                    initialData: LoginResponse(
                      accessToken: accessToken,
                      refreshToken: refreshToken,
                      user: ProfilePictureUserEntity.fromUserEntity(
                        user,
                        profilePictureUrl,
                      ),
                      gym: gym,
                    ),
                    initialPassword: password,
                  );
                } else {
                  Future.delayed(
                    Duration.zero,
                    () {
                      final nav = Navigator.of(context)
                        ..pushReplacement(
                          CupertinoPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      if (!user.confirmed) {
                        nav
                            .push<LoginResponse>(
                              CupertinoPageRoute(
                                builder: (context) => ConfirmEmailPage(
                                  password: password,
                                  email: user.email,
                                ),
                              ),
                            )
                            .then(
                              (response) => response != null
                                  ? Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => HomePage(
                                          initialData: response,
                                          initialPassword: password,
                                        ),
                                      ),
                                      (_) => false,
                                    )
                                  : null,
                            );
                      }
                    },
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
