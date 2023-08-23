part of '../home.dart';

typedef UserBloc = AuthLoaderBloc<void, HttpResponse<GetUserResponse>>;
typedef UserConsumer = AuthLoaderConsumer<void, HttpResponse<GetUserResponse>>;

extension on BuildContext {
  UserBloc get userBloc => authLoader();
}
