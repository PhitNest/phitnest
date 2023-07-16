import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api.dart';
import '../bloc/loader.dart';
import '../cognito/cognito.dart';
import '../http/http.dart';
import 'styled/styled_banner.dart';

final class AuthProvider extends StatelessWidget {
  /// API info loaded from cache or null if there is no info cached
  final ApiInfo? apiInfo;
  final Widget loader;
  final void Function(BuildContext, Session) onSessionRestored;
  final void Function(BuildContext, ApiInfo) onSessionRestoreFailed;

  const AuthProvider({
    super.key,
    required this.apiInfo,
    required this.loader,
    required this.onSessionRestored,
    required this.onSessionRestoreFailed,
  }) : super();

  bool get apiInfoCached => apiInfo != null;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            // Load API info from server
            create: (_) => LoaderBloc<void, HttpResponse<ApiInfo>>(
              load: (_) => requestApiInfo(
                // We already tried reading from cache, so don't try again
                readFromCache: false,
                writeToCache: true,
                useAdmin: false,
              ),
              initialData: apiInfoCached ? HttpResponseCache(apiInfo!) : null,
              // If API info is not cached, load it on start, if it is
              // cached, we will be in the loaded state already because
              // we passed it into initialData
              loadOnStart: apiInfoCached ? null : (req: null),
            ),
          ),
          BlocProvider(
            create: (_) => LoaderBloc<ApiInfo, RefreshSessionResponse>(
              load: (apiInfo) => getPreviousSession(apiInfo),
              // If we have API info cached, try restoring session on
              // start
              loadOnStart: apiInfoCached ? (req: apiInfo!) : null,
            ),
          ),
        ],
        child: BlocConsumer<LoaderBloc<void, HttpResponse<ApiInfo>>,
            LoaderState<HttpResponse<ApiInfo>>>(
          listener: (context, apiInfoState) {
            switch (apiInfoState) {
              case LoaderLoadedState(data: final apiInfoResponse):
                switch (apiInfoResponse) {
                  // This indicates that we failed to load API info from
                  // the server
                  case HttpResponseFailure(failure: final failure):
                    // Show error message if we failed to load API info
                    // from server
                    StyledBanner.show(
                      message: failure.message,
                      error: true,
                    );
                    // Retry loading API info from server
                    BlocProvider.of<LoaderBloc<void, HttpResponse<ApiInfo>>>(
                            context)
                        .add(const LoaderLoadEvent(null));
                  // This indicates that we successfully loaded API info
                  // from server, so now we should try restoring session
                  case HttpResponseSuccess(data: final apiInfo):
                    BlocProvider.of<
                                LoaderBloc<ApiInfo, RefreshSessionResponse>>(
                            context)
                        .add(LoaderLoadEvent(apiInfo));
                }
              default:
            }
          },
          builder: (context, apiInfoState) => switch (apiInfoState) {
            // If we are loading API info from server, show loader
            LoaderInitialState() || LoaderLoadingState() => loader,
            LoaderLoadedState(data: final apiInfoResponse) => switch (
                  apiInfoResponse) {
                // If we failed to load API info from server, show loader
                HttpResponseFailure() => loader,
                // We successfully loaded API info from either cache or
                // server
                HttpResponseSuccess() => BlocConsumer<
                      LoaderBloc<ApiInfo, RefreshSessionResponse>,
                      LoaderState<RefreshSessionResponse>>(
                    listener: (context, restoreSessionState) {
                      switch (restoreSessionState) {
                        case LoaderLoadedState(data: final sessionResponse):
                          switch (sessionResponse) {
                            // This indicates that we failed to restore
                            // a session
                            case RefreshSessionFailureResponse():
                              switch (apiInfoResponse) {
                                // Since the cached API info may be out
                                // of date, try to load it from server
                                case HttpResponseCache():
                                  BlocProvider.of<
                                          LoaderBloc<void,
                                              HttpResponse<ApiInfo>>>(context)
                                      .add(const LoaderLoadEvent(null));
                                case HttpResponseOk(data: final apiInfo):
                                  // We failed to restore session but we have
                                  // API info from the server so there is
                                  // nothing left to be done
                                  onSessionRestoreFailed(context, apiInfo);
                              }
                            case RefreshSessionSuccess(
                                newSession: final session
                              ):
                              // We successfully restored session
                              onSessionRestored(context, session);
                          }
                        default:
                      }
                    },
                    builder: (context, _) => loader,
                  )
              },
          },
        ),
      );
}
