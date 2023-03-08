import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:phitnest_utils/cache_adapter.dart';
import 'package:phitnest_utils/utils.dart';

import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  initializeHttpAdapter(
      dotenv.get('BACKEND_HOST'), dotenv.get('BACKEND_PORT', fallback: ""));
  await initializeCacheAdapter();
  runApp(const App());
}
