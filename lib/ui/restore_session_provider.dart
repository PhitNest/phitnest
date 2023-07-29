import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api.dart';
import '../bloc/loader.dart';
import '../bloc/session.dart';
import '../cognito/cognito.dart';
import '../http/http.dart';
import 'styled/styled_banner.dart';

typedef ApiInfoBloc = LoaderBloc<void, HttpResponse<ApiInfo>>;
typedef ApiInfoConsumer = LoaderConsumer<void, HttpResponse<ApiInfo>>;
typedef RestoreSessionBloc = LoaderBloc<void, RefreshSessionResponse>;
typedef RestoreSessionConsumer = LoaderConsumer<void, RefreshSessionResponse>;

extension on BuildContext {
  ApiInfoBloc get apiInfoBloc => loader();
}

final class RestoreSessionProvider extends StatelessWidget {
  final Widget loader;
  final bool useAdminAuth;
  final PageRoute<void> Function(ApiInfo) onSessionRestored;
  final PageRoute<void> Function(ApiInfo) onSessionRestoreFailed;

  const RestoreSessionProvider({
    super.key,
    required this.loader,
    required this.onSessionRestored,
    required this.onSessionRestoreFailed,
    required this.useAdminAuth,
  }) : super();

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => ApiInfoBloc(
          load: (_) => requestApiInfo(
            readFromCache: true,
            writeToCache: true,
            useAdmin: useAdminAuth,
          ),
          loadOnStart: (req: null),
        ),
        child: ApiInfoConsumer(
          listener: (context, apiInfoState) {
            switch (apiInfoState) {
              case LoaderLoadedState(data: final apiInfoResponse):
                switch (apiInfoResponse) {
                  case HttpResponseFailure(failure: final failure):
                    // Show error message if we failed to load API info from
                    // server
                    StyledBanner.show(
                      message: failure.message,
                      error: true,
                    );
                    // Retry loading API info from server
                    context.apiInfoBloc.add(const LoaderLoadEvent(null));
                  // This indicates that we successfully loaded API info from
                  // server, but our cache was empty so a session will not be
                  // restored.
                  case HttpResponseOk(data: final apiInfo):
                    Navigator.pushReplacement(
                        context, onSessionRestoreFailed(apiInfo));
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
                    create: (_) => RestoreSessionBloc(
                      load: (_) => getPreviousSession(cachedApiInfo),
                      loadOnStart: (req: null),
                    ),
                    child: RestoreSessionConsumer(
                      listener: (context, restoreSessionState) {
                        switch (restoreSessionState) {
                          case LoaderLoadedState(
                              data: final restoreSessionResponse
                            ):
                            switch (restoreSessionResponse) {
                              case RefreshSessionFailureResponse():
                                Navigator.pushReplacement(
                                  context,
                                  onSessionRestoreFailed(
                                    cachedApiInfo,
                                  ),
                                );
                              case RefreshSessionSuccess(
                                  newSession: final newSession
                                ):
                                context.sessionLoader.add(LoaderSetEvent(
                                    RefreshSessionSuccess(newSession)));
                                Navigator.pushReplacement(
                                  context,
                                  onSessionRestored(newSession.apiInfo),
                                );
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
