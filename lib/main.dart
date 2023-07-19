import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

import 'screens/login_screen.dart';

final class Loader extends StatelessWidget {
  const Loader({
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
}

Future<void> main() => runPhitNest(
      useAdminAuth: false,
      useScreenUtils: true,
      title: 'PhitNest',
      loader: const Loader(),
      sessionRestoredBuilder: (apiInfo) => CupertinoPageRoute(
        builder: (context) => HomeScreen(apiInfo: apiInfo),
      ),
      sessionRestoreFailedBuilder: (apiInfo) => CupertinoPageRoute(
        builder: (context) => LoginScreen(apiInfo: apiInfo),
      ),
    );
