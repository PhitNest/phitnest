import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import 'screens/login/ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeCache();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key}) : super();

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(true),
          )
        ],
        child: MaterialApp(
          title: 'PhitNest Admin',
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (_) => const LoginScreen(),
          },
        ),
      );
}
