part of 'home.dart';

typedef ExploreBloc
    = AuthLoaderBloc<void, HttpResponse<List<UserExploreWithPicture>>>;
typedef ExploreConsumer
    = AuthLoaderConsumer<void, HttpResponse<List<UserExploreWithPicture>>>;

typedef SendFriendRequestBloc
    = AuthLoaderBloc<String, HttpResponse<FriendshipResponse>>;
typedef SendFriendRequestConsumer
    = AuthLoaderConsumer<String, HttpResponse<FriendshipResponse>>;

typedef UserBloc = AuthLoaderBloc<void, HttpResponse<GetUserResponse>>;
typedef UserConsumer = AuthLoaderConsumer<void, HttpResponse<GetUserResponse>>;

extension HomeBlocGetters on BuildContext {
  UserBloc get userBloc => authLoader();
  ExploreBloc get exploreBloc => authLoader();
  SendFriendRequestBloc get sendFriendRequestBloc => authLoader();
}
