import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ui/screens/screens.dart';
import 'ui/theme.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(375, 667),
        builder: (context, child) => MaterialApp(
          title: 'PhitNest',
          theme: theme,
          debugShowCheckedModeBanner: false,
          home: ConversationsProvider(),
        ),
      );
}
