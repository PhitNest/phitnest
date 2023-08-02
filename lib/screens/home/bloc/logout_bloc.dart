part of '../home.dart';

typedef LogoutBloc = LoaderBloc<void, void>;
typedef LogoutConsumer = LoaderConsumer<void, void>;

extension on BuildContext {
  LogoutBloc get logoutBloc => loader();
}
