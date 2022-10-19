import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/repositories/repositories.dart' as repositories;

/// This is the driver function for the flutter application, [App].
/// This calls [repositories.setup], which must not be called again.
/// Data repositories should not be accessed before calling [repositories.setup]
main() {
  WidgetsFlutterBinding.ensureInitialized();
  repositories.setup();
  runApp(App());
}
