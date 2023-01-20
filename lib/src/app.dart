import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_mobile/src/presentation/pages/registration/ui/registration_page.dart';

import 'app_bloc.dart';
import 'common/theme.dart';

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
                // final user = deviceCache.cachedUser;
                // if (user != null) {
                //   if (user.confirmed) {
                //     return const HomePage();
                //   } else {
                //     return ConfirmEmailPage(email: user.email);
                //   }
                //  } else {
                return RegistrationPage();
                //}
              },
            ),
          ),
        ),
      );
}
