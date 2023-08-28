import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

import 'pages/home/home.dart';
import 'pages/login/login.dart';

Future<void> main() => runPhitNest(
      useAdminAuth: true,
      title: 'PhitNest Admin',
      sessionRestoredBuilder: (context, session) =>
          Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (context) => HomePage(apiInfo: session.apiInfo),
        ),
        (_) => false,
      ),
      sessionRestoreFailedBuilder: (context, apiInfo) =>
          Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (context) => LoginPage(apiInfo: apiInfo),
        ),
        (_) => false,
      ),
    );
