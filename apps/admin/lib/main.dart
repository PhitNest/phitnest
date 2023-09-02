import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import 'pages/pages.dart';

Future<void> main() => runPhitNest(
      useAdminAuth: true,
      title: 'PhitNest Admin',
      sessionRestoredBuilder: (context, session) =>
          Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const HomePage(),
        ),
        (_) => false,
      ),
      sessionRestoreFailedBuilder: (context) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const LoginPage(),
        ),
        (_) => false,
      ),
    );
