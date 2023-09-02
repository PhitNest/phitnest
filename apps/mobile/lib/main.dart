import 'package:flutter/cupertino.dart';
import 'package:ui/ui.dart';

import 'pages/pages.dart';

Future<void> main() => runPhitNest(
      useAdminAuth: false,
      title: 'PhitNest',
      sessionRestoredBuilder: (context, session) =>
          Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute<void>(
          builder: (_) => const HomePage(),
        ),
        (_) => false,
      ),
      sessionRestoreFailedBuilder: (context) => Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute<void>(
          builder: (_) => const LoginPage(),
        ),
        (_) => false,
      ),
    );
