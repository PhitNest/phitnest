import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api.dart';
import '../aws/aws.dart';
import '../bloc/loader/loader.dart';
import '../http/http.dart';
import 'styled/styled.dart';

typedef ApiInfoBloc = LoaderBloc<bool, HttpResponse<ApiInfo>>;
typedef ApiInfoConsumer = LoaderConsumer<bool, HttpResponse<ApiInfo>>;
typedef RestoreSessionBloc = LoaderBloc<ApiInfo, RefreshSessionResponse>;
typedef RestoreSessionConsumer
    = LoaderConsumer<ApiInfo, RefreshSessionResponse>;

extension on BuildContext {
  ApiInfoBloc get apiInfoBloc => loader();
}

final class RestoreSessionProvider extends StatelessWidget {
  final bool useAdminAuth;
  final void Function(BuildContext context, Session session) onSessionRestored;
  final void Function(BuildContext context, ApiInfo apiInfo)
      onSessionRestoreFailed;

  const RestoreSessionProvider({
    super.key,
    required this.onSessionRestored,
    required this.onSessionRestoreFailed,
    required this.useAdminAuth,
  }) : super();

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => ApiInfoBloc(
          load: requestApiInfo,
          loadOnStart: (req: useAdminAuth),
        ),
        child: ApiInfoConsumer(
          listener: (context, apiInfoState) {
            switch (apiInfoState) {
              case LoaderLoadedState(data: final apiInfoResponse):
                switch (apiInfoResponse) {
                  case HttpResponseFailure(failure: final failure):
                    StyledBanner.show(message: failure.message, error: true);
                    context.apiInfoBloc.add(LoaderLoadEvent(useAdminAuth));
                  default:
                }
              default:
            }
          },
          builder: (context, apiInfoState) => switch (apiInfoState) {
            LoaderLoadedState(data: final apiInfoResponse) => switch (
                  apiInfoResponse) {
                HttpResponseSuccess(data: final apiInfo) => BlocProvider(
                    create: (_) => RestoreSessionBloc(
                      load: getPreviousSession,
                      loadOnStart: (req: apiInfo),
                    ),
                    child: RestoreSessionConsumer(
                      listener: (context, restoreSessionState) {
                        switch (restoreSessionState) {
                          case LoaderLoadedState(
                              data: final restoreSessionResponse
                            ):
                            switch (restoreSessionResponse) {
                              case RefreshSessionFailureResponse():
                                onSessionRestoreFailed(context, apiInfo);
                              case RefreshSessionSuccess(
                                  newSession: final newSession
                                ):
                                onSessionRestored(context, newSession);
                            }
                          default:
                        }
                      },
                      builder: (context, restoreSessionState) => const Loader(),
                    ),
                  ),
                _ => const Loader(),
              },
            _ => const Loader(),
          },
        ),
      );
}
