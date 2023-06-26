import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import 'src/screens/home/ui.dart';
import 'src/screens/on_boarding/ui.dart';
import 'src/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  Widget build(BuildContext context) => ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(375, 667),
        builder: (context, child) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => CognitoBloc(false),
              lazy: false,
            ),
          ],
          child: MaterialApp(
            title: 'PhitNest',
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: BlocConsumer<CognitoBloc, CognitoState>(
              listener: (context, cognitoState) {},
              builder: (context, cognitoState) => switch (cognitoState) {
                CognitoLoggedInState() => const HomeScreen(),
                _ => const OnBoardingScreen(),
              },
            ),
          ),
        ),
      );
}
