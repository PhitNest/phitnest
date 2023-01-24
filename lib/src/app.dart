import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_bloc.dart';
import 'common/theme.dart';
import 'data/data_sources/cache/cache.dart';
import 'presentation/pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(375, 667),
        builder: (context, child) => BlocProvider(
          create: (context) => AppBloc(),
          child: MaterialApp(
            title: 'PhitNest',
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (context) {
                final user = deviceCache.cachedUser;
                final password = deviceCache.cachedPassword;
                if (user != null) {
                  if (user.confirmed) {
                    return const HomePage();
                  } else if (password != null) {
                    return ConfirmEmailPage(
                      email: user.email,
                      password: password,
                      onConfirmed: () => Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => HomePage(),
                        ),
                        (_) => false,
                      ),
                    );
                  }
                }
                return OnBoardingPage();
              },
            ),
          ),
        ),
      );
}
