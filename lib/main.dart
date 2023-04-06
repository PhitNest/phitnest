import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  initializeHttp(
      host: dotenv.get('BACKEND_HOST'),
      port: dotenv.get('BACKEND_PORT', fallback: ""));
  await initializeCache();
  runApp(const App());
}
