part of '../home.dart';

typedef ExploreBloc = AuthLoaderBloc<void, HttpResponse<List<UserExplore>>>;
typedef ExploreConsumer
    = AuthLoaderConsumer<void, HttpResponse<List<UserExplore>>>;

extension on BuildContext {
  ExploreBloc get exploreBloc => authLoader();
}
