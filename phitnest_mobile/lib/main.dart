import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/repositories/repositories.dart' as repositories;

main() {
  WidgetsFlutterBinding.ensureInitialized();
  repositories.setup();
  runApp(App());
}
