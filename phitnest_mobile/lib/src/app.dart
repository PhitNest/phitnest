import 'package:flutter/material.dart';

import 'constants/routes.dart';
import 'ui/theme.dart';

Route<dynamic> generateRoute(RouteSettings settings) => MaterialPageRoute(
    builder: (_) =>
        (kRouteMap[settings.name] ?? kRouteMap['default']!)(settings),
    settings: settings);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Phitnest',
        theme: theme,
        debugShowCheckedModeBanner: false,
        initialRoute: kOnBoarding,
        onGenerateRoute: generateRoute,
      );
}
