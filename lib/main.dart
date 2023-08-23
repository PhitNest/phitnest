import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          builder: (context) => HomeScreen(initialSession: session),
        ),
        (_) => false,
      ),
      sessionRestoreFailedBuilder: (apiInfo) => CupertinoPageRoute(
        builder: (context) => LoginScreen(apiInfo: apiInfo),
      ),
    );
