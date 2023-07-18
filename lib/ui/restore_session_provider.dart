import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api.dart';
import '../bloc/loader.dart';
import '../cognito/cognito.dart';
import '../http/http.dart';
import 'styled/styled_banner.dart';

final class RestoreSessionProvider extends StatelessWidget {
  final Widget loader;
  final bool useAdminAuth;
  final void Function(BuildContext, Session) onSessionRestored;
  final void Function(BuildContext, ApiInfo) onSessionRestoreFailed;

  const RestoreSessionProvider({
    super.key,
    required this.loader,
    required this.onSessionRestored,
    required this.onSessionRestoreFailed,
    required this.useAdminAuth,
  }) : super();

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => LoaderBloc<void, HttpResponse<ApiInfo>>(
          load: (_) => requestApiInfo(
            readFromCache: true,
            writeToCache: true,
            useAdmin: useAdminAuth,
          ),
          loadOnStart: (req: null),
        ),
        child: LoaderConsumer<void, HttpResponse<ApiInfo>>(
          listener: (context, apiInfoState) {
            switch (apiInfoState) {
              case LoaderLoadedState(data: final apiInfoResponse):
                switch (apiInfoResponse) {
                  // This indicates that we failed to load API info from the
                  // server
                  case HttpResponseFailure(failure: final failure):
                    // Show error message if we failed to load API info from
                    // server
                    StyledBanner.show(
                      message: failure.message,
                      error: true,
                    );
                    // Retry loading API info from server
                    context
                        .loader<void, HttpResponse<ApiInfo>>()
                        .add(const LoaderLoadEvent(null));
                  // This indicates that we successfully loaded API info from
                  // server, but our cache was empty so a session will not be
                  // restored.
                  case HttpResponseOk(data: final apiInfo):
                    onSessionRestoreFailed(context, apiInfo);
                  case HttpResponseCache():
                }
              default:
            }
          },
          builder: (context, apiInfoState) => switch (apiInfoState) {
            LoaderInitialState() || LoaderLoadingState() => loader,
            LoaderLoadedState(data: final apiInfoResponse) => switch (
                  apiInfoResponse) {
                // This indicates that we successfully loaded API info from the
                // cache, so a session might be restorable.
                HttpResponseCache(data: final cachedApiInfo) => BlocProvider(
                    create: (_) => LoaderBloc<void, RefreshSessionResponse>(
                      load: (_) => getPreviousSession(cachedApiInfo),
                      loadOnStart: (req: null),
                    ),
                    child: LoaderConsumer<void, RefreshSessionResponse>(
                      listener: (context, restoreSessionState) {
                        switch (restoreSessionState) {
                          case LoaderLoadedState(
                              data: final restoreSessionResponse
                            ):
                            switch (restoreSessionResponse) {
                              case RefreshSessionFailureResponse():
                                onSessionRestoreFailed(
                                  context,
                                  cachedApiInfo,
                                );
                              case RefreshSessionSuccess(
                                  newSession: final newSession
                                ):
                                onSessionRestored(context, newSession);
                            }
                          default:
                        }
                      },
                      builder: (context, restoreSessionState) => loader,
                    ),
                  ),
                _ => loader,
              }
          },
        ),
      );
}
