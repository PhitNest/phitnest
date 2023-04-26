import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'router.dart';
import 'theme.dart';

void main() {
  Routemaster.setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'PhitNest Admin',
      theme: theme,
      debugShowCheckedModeBanner: false,
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) => appRouter.loggedOutRoute,
      ),
    );
  }
}
