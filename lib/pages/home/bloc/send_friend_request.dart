part of '../home.dart';

typedef SendFriendRequestBloc = AuthLoaderBloc<String, HttpResponse<void>>;
typedef SendFriendRequestConsumer
    = AuthLoaderConsumer<String, HttpResponse<void>>;

extension on BuildContext {
  SendFriendRequestBloc get sendFriendRequestBloc => authLoader();
}
