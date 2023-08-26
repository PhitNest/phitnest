import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() => runPhitNest(
      useAdminAuth: true,
      title: 'PhitNest Admin',
      sessionRestoredBuilder: (context, session) =>
          Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (context) => HomeScreen(apiInfo: session.apiInfo),
        ),
        (_) => false,
      ),
      sessionRestoreFailedBuilder: (context, apiInfo) =>
          Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (context) => LoginScreen(apiInfo: apiInfo),
        ),
        (_) => false,
      ),
    );
