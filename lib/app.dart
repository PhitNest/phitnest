import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'api/api.dart';
import 'bloc/session.dart';
import 'cache.dart';
import 'http/http.dart';
import 'ui/ui.dart';

Future<void> runPhitNest({
  required bool useScreenUtils,
  required bool useAdminAuth,
  required String title,
  required Widget loader,
  required PageRoute<void> Function(ApiInfo) sessionRestoreFailedBuilder,
  required PageRoute<void> Function(ApiInfo) sessionRestoredBuilder,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  initializeHttp(
      host: dotenv.get('BACKEND_HOST'),
      port: dotenv.get('BACKEND_PORT', fallback: ''));
  await initializeCache();
  initializeTheme(useScreenUtils);
  runApp(
    PhitNestApp(
      useAdminAuth: useAdminAuth,
      title: title,
      useScreenUtil: useScreenUtils,
      loader: loader,
      sessionRestoreFailedBuilder: sessionRestoreFailedBuilder,
      sessionRestoredBuilder: sessionRestoredBuilder,
    ),
  );
}

final class PhitNestApp extends StatelessWidget {
  final bool useScreenUtil;
  final bool useAdminAuth;
  final String title;
  final Widget loader;
  final PageRoute<void> Function(ApiInfo) sessionRestoreFailedBuilder;
  final PageRoute<void> Function(ApiInfo) sessionRestoredBuilder;

  const PhitNestApp({
    Key? key,
    required this.useScreenUtil,
    required this.title,
    required this.useAdminAuth,
    required this.loader,
    required this.sessionRestoreFailedBuilder,
    required this.sessionRestoredBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    builder(BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => SessionBloc(
                load: (session) => session.refreshSession(),
              ),
            ),
          ],
          child: MaterialApp(
            title: title,
            theme: theme,
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: StyledBanner.scaffoldMessengerKey,
            home: RestoreSessionProvider(
              useAdminAuth: useAdminAuth,
              loader: loader,
              onSessionRestoreFailed: sessionRestoreFailedBuilder,
              onSessionRestored: sessionRestoredBuilder,
            ),
          ),
        );
    if (useScreenUtil) {
      return ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(375, 667),
        builder: (context, _) => builder(context),
      );
    } else {
      return builder(context);
    }
  }
}
