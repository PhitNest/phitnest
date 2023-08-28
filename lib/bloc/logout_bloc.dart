import 'package:flutter/material.dart';

import '../api/api.dart';
import '../aws/aws.dart';
import 'loader/loader.dart';

typedef LogoutBloc = AuthLoaderBloc<void, void>;
typedef LogoutConsumer = AuthLoaderConsumer<void, void>;

extension LogoutBlocGetter on BuildContext {
  LogoutBloc get logoutBloc => authLoader();
}

LogoutBloc createLogoutBloc(ApiInfo apiInfo, BuildContext context) =>
    LogoutBloc(
      apiInfo: apiInfo,
      load: (_, session) async {
        await logout(session);
        context.sessionLoader.add(const LoaderSetEvent(SessionReset()));
      },
    );
