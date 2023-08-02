import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

import 'screens/home/home.dart';
import 'screens/login/login.dart';
import 'widgets/widgets.dart';

Future<void> main() => runPhitNest(
      useAdminAuth: false,
      useScreenUtils: true,
      title: 'PhitNest',
      loader: const Scaffold(
        body: Loader(),
      ),
      sessionRestoredBuilder: (apiInfo) => CupertinoPageRoute(
        builder: (context) => HomeScreen(apiInfo: apiInfo),
      ),
      sessionRestoreFailedBuilder: (apiInfo) => CupertinoPageRoute(
        builder: (context) => LoginScreen(apiInfo: apiInfo),
      ),
    );
