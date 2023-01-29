import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/common/shared_preferences.dart';
import 'src/data/adapters/adapters.dart';
import 'src/data/data_sources/backend/backend.dart';
import 'src/domain/entities/entities.dart';
import 'src/presentation/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await dotenv.load();
  await loadPreferences();
  injectAdapters();
  injectEntities();
  injectRequests();
  injectResponses();
  runApp(
    App(),
  );
}
