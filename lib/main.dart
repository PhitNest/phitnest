import 'package:flutter/cupertino.dart';
import 'package:phitnest_core/core.dart';

import 'pages/pages.dart';

Future<void> main() => runPhitNest(
      useAdminAuth: false,
      title: 'PhitNest',
      sessionRestoredBuilder: (context, session) =>
          Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute<void>(
          builder: (context) => HomePage(apiInfo: session.apiInfo),
        ),
        (_) => false,
      ),
      sessionRestoreFailedBuilder: (context, apiInfo) =>
          Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute<void>(
          builder: (context) => LoginPage(apiInfo: apiInfo),
        ),
        (_) => false,
      ),
    );
