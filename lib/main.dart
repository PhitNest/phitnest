import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:phitnest_core/core.dart';

import 'router.dart';
import 'widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await dotenv.load();
  initializeHttp(
      host: dotenv.get('BACKEND_HOST'),
      port: dotenv.get('BACKEND_PORT', fallback: ''));
  await initializeCache();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key}) : super();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CognitoBloc(true),
        ),
      ],
      child: MaterialApp.router(
        scaffoldMessengerKey: StyledBanner.scaffoldMessengerKey,
        title: 'PhitNest Admin',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
