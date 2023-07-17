import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phitnest_core/core.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  initializeHttp(
      host: dotenv.get('BACKEND_HOST'),
      port: dotenv.get('BACKEND_PORT', fallback: ''));
  await initializeCache();
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
  Widget build(BuildContext context) => MaterialApp(
        title: 'PhitNest Admin',
        theme: AppTheme.instance.theme,
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: StyledBanner.scaffoldMessengerKey,
        home: RestoreSessionProvider(
          useAdminAuth: true,
          loader: const Loader(),
          onSessionRestoreFailed: (context, apiInfo) =>
              Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (context) => LoginScreen(
                apiInfo: apiInfo,
              ),
            ),
          ),
          onSessionRestored: (context, session) => Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (context) => HomeScreen(
                session: session,
              ),
            ),
          ),
        ),
      );
}
