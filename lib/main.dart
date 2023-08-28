import 'package:flutter/cupertino.dart';
import 'package:phitnest_core/core.dart';

import 'screens/home/home.dart';
import 'screens/login/login.dart';

Future<void> main() => runPhitNest(
      useAdminAuth: false,
      title: 'PhitNest',
      sessionRestoredBuilder: (context, session) =>
          Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute<void>(
          builder: (context) => HomeScreen(apiInfo: session.apiInfo),
        ),
        (_) => false,
      ),
      sessionRestoreFailedBuilder: (context, apiInfo) =>
          Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute<void>(
          builder: (context) => LoginScreen(apiInfo: apiInfo),
        ),
        (_) => false,
      ),
    );
