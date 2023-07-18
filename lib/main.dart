import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  initializeHttp(
      host: dotenv.get('BACKEND_HOST'),
      port: dotenv.get('BACKEND_PORT', fallback: ''));
  await initializeCache();
  AppTheme.useScreenUtils = true;
  runApp(const App());
}

final class Loader extends StatelessWidget {
  const Loader({
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
}

final class App extends StatelessWidget {
  const App({
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(375, 667),
        builder: (context, _) => MaterialApp(
          title: 'PhitNest',
          theme: AppTheme.instance.theme,
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: StyledBanner.scaffoldMessengerKey,
          home: RestoreSessionProvider(
            useAdminAuth: false,
            loader: const Loader(),
            onSessionRestoreFailed: (context, apiInfo) =>
                Navigator.pushReplacement(
              context,
              CupertinoPageRoute<void>(
                builder: (context) => const Scaffold(),
              ),
            ),
            onSessionRestored: (context, session) => Navigator.pushReplacement(
              context,
              CupertinoPageRoute<void>(
                builder: (context) => const Scaffold(),
              ),
            ),
          ),
        ),
      );
}
