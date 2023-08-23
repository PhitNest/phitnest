part of '../home.dart';

typedef LogoutBloc = AuthLoaderBloc<void, void>;
typedef LogoutConsumer = AuthLoaderConsumer<void, void>;

extension on BuildContext {
  LogoutBloc get logoutBloc => authLoader();
}
