import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() => runPhitNest(
      useAdminAuth: true,
      useScreenUtils: false,
      title: 'PhitNest Admin',
      loader: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      sessionRestoredBuilder: (apiInfo) => MaterialPageRoute(
        builder: (context) => HomeScreen(apiInfo: apiInfo),
      ),
      sessionRestoreFailedBuilder: (apiInfo) => MaterialPageRoute(
        builder: (context) => LoginScreen(apiInfo: apiInfo),
      ),
    );
