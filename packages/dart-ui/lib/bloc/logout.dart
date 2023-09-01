import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'loader.dart';

typedef LogoutBloc = AuthLoaderBloc<void, void>;
typedef LogoutConsumer = AuthLoaderConsumer<void, void>;

extension LogoutBlocGetter on BuildContext {
  LogoutBloc get logoutBloc => authLoader();
}

LogoutBloc logoutBloc(BuildContext context) => LogoutBloc(
      load: (_, session) async {
        context.sessionLoader.add(const LoaderSetEvent(SessionEnded()));
        await logout(session);
      },
    );
