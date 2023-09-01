import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../styled/styled.dart';

typedef RestorePreviousSessionBloc = LoaderBloc<void, RefreshSessionResponse>;
typedef RestorePreviousSessionConsumer
    = LoaderConsumer<void, RefreshSessionResponse>;

final class RestorePreviousSessionProvider extends StatelessWidget {
  final bool useAdminAuth;
  final void Function(BuildContext context, Session session) onSessionRestored;
  final void Function(BuildContext context) onSessionRestoreFailed;

  const RestorePreviousSessionProvider({
    super.key,
    required this.onSessionRestored,
    required this.onSessionRestoreFailed,
    required this.useAdminAuth,
  }) : super();

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => RestorePreviousSessionBloc(
          load: (_) => getPreviousSession(),
          loadOnStart: const LoadOnStart(null),
        ),
        child: RestorePreviousSessionConsumer(
          listener: (context, restoreSessionState) {
            switch (restoreSessionState) {
              case LoaderLoadedState(data: final restoreSessionResponse):
                switch (restoreSessionResponse) {
                  case RefreshSessionFailureResponse():
                    onSessionRestoreFailed(context);
                  case RefreshSessionSuccess(newSession: final newSession):
                    onSessionRestored(context, newSession);
                }
              default:
            }
          },
          builder: (context, restoreSessionState) => const Loader(),
        ),
      );
}
