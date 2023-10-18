import 'package:core/core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ui/ui.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

Future<void> runPhitNest({
  required bool useAdminAuth,
  required String title,
  required void Function(BuildContext context) sessionRestoreFailedBuilder,
  required void Function(BuildContext context, Session session)
      sessionRestoredBuilder,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeCache();
  initializeAws(useAdminAuth);
  runApp(
    PhitNestApp(
      useAdminAuth: useAdminAuth,
      title: title,
      sessionRestoreFailedBuilder: sessionRestoreFailedBuilder,
      sessionRestoredBuilder: sessionRestoredBuilder,
    ),
  );
}

final class PhitNestApp extends StatelessWidget {
  final bool useAdminAuth;
  final String title;
  final void Function(BuildContext context) sessionRestoreFailedBuilder;
  final void Function(BuildContext context, Session session)
      sessionRestoredBuilder;

  const PhitNestApp({
    Key? key,
    required this.title,
    required this.useAdminAuth,
    required this.sessionRestoreFailedBuilder,
    required this.sessionRestoredBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(375, 667),
        builder: (context, _) => BlocProvider(
          create: (_) => SessionBloc(load: refreshSession),
          child: GestureDetector(
            onTap: () {
              final currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: MaterialApp(
              title: title,
              theme: theme,
              scrollBehavior: AppScrollBehavior(),
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: StyledBanner.scaffoldMessengerKey,
              home: Scaffold(
                body: RestorePreviousSessionProvider(
                  useAdminAuth: useAdminAuth,
                  onSessionRestoreFailed: sessionRestoreFailedBuilder,
                  onSessionRestored: sessionRestoredBuilder,
                ),
              ),
            ),
          ),
        ),
      );
}
