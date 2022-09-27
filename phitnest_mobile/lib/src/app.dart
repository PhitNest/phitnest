import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'routes.dart';
import 'ui/theme.dart';

Route<dynamic> generateRoute(RouteSettings settings) => MaterialPageRoute(
    builder: (_) =>
        (kRouteMap[settings.name] ?? kRouteMap['default']!)(settings),
    settings: settings);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(375, 667),
      builder: (context, child) => MaterialApp(
            title: 'PhitNest',
            theme: theme,
            debugShowCheckedModeBanner: false,
            initialRoute: kOnBoarding,
            onGenerateRoute: generateRoute,
          ));
}
