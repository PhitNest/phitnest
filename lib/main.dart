import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/common/shared_preferences.dart';
import 'src/data/adapters/adapters.dart';
import 'src/app.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await dotenv.load();
  await loadPreferences();
  injectAdapters();
  runApp(
    App(),
  );
}
