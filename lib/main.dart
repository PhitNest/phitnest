import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/common/shared_preferences.dart';
import 'src/data/cache/cache.dart';
import 'src/presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await dotenv.load();
  await loadPreferences();
  await CachedNetworkImage.evictFromCache(Cache.profilePictureImageCache);
  runApp(
    App(),
  );
}
