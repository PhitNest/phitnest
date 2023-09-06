part of 'home.dart';

typedef SendFriendRequestBloc = AuthParallelLoaderBloc<UserExploreWithPicture,
    HttpResponse<FriendshipResponse>>;
typedef SendFriendRequestConsumer = AuthParallelLoaderConsumer<
    UserExploreWithPicture, HttpResponse<FriendshipResponse>>;

typedef DeleteUserBloc = AuthLoaderBloc<void, HttpResponse<bool>>;
typedef DeleteUserConsumer = AuthLoaderConsumer<void, HttpResponse<bool>>;

typedef UserBloc = AuthLoaderBloc<void, HttpResponse<GetUserResponse>>;
typedef UserConsumer = AuthLoaderConsumer<void, HttpResponse<GetUserResponse>>;

extension HomeBlocGetters on BuildContext {
  UserBloc get userBloc => authLoader();
  SendFriendRequestBloc get sendFriendRequestBloc => authParallelBloc();
  DeleteUserBloc get deleteUserBloc => authLoader();
}

void _goToLogin(BuildContext context, String? error) {
  if (error != null) {
    StyledBanner.show(message: error, error: true);
  }
  Navigator.pushAndRemoveUntil(
    context,
    CupertinoPageRoute<void>(
      builder: (context) => const LoginPage(),
    ),
    (_) => false,
  );
}

void _handleLogoutStateChanged(
  BuildContext context,
  LoaderState<void> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState():
      _goToLogin(context, null);
    default:
  }
}

Future<void> _handleGetUserStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<HttpResponse<GetUserResponse>>> loaderState,
  NavBarState navBarState,
) async {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case AuthLost(message: final message):
          _goToLogin(context, message);
        case AuthRes(data: final response):
          switch (response) {
            case HttpResponseFailure(failure: final failure):
              StyledBanner.show(
                message: failure.message,
                error: true,
              );
              context.userBloc
                  .add(LoaderLoadEvent(AuthReq(null, context.sessionLoader)));
            case HttpResponseSuccess(data: final response):
              switch (response) {
                case GetUserSuccess(
                    exploreUsers: final exploreUsers,
                    receivedFriendRequests: final receivedRequests,
                  ):
                  context.navBarBloc
                      .add(NavBarSetNumAlertsEvent(receivedRequests.length));
                  switch (navBarState) {
                    case NavBarInitialState(page: final page):
                      if (page == NavBarPage.explore &&
                          exploreUsers.isNotEmpty) {
                        context.navBarBloc.add(const NavBarAnimateEvent());
                      } else {
                        context.navBarBloc
                            .add(const NavBarSetLoadingEvent(false));
                      }
                    default:
                  }
                case FailedToLoadProfilePicture():
                  Image? image;
                  final userBloc = context.userBloc;
                  while (image == null) {
                    image = await Navigator.push(
                      context,
                      CupertinoPageRoute<Image>(
                        builder: (_) => const PhotoInstructionsPage(),
                      ),
                    );
                  }
                  userBloc.add(LoaderSetEvent(
                      AuthRes(HttpResponseOk(response.copyWith(image), null))));
                default:
              }
          }
      }
    default:
  }
}

void _handleDeleteUserStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<HttpResponse<bool>>> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case AuthRes(data: final response):
          switch (response) {
            case HttpResponseSuccess(data: final deleted):
              if (deleted) {
                _goToLogin(context, null);
              } else {
                StyledBanner.show(
                  message: 'Failed to delete user',
                  error: true,
                );
              }
            case HttpResponseFailure(failure: final failure):
              StyledBanner.show(
                message: failure.message,
                error: true,
              );
          }
        case AuthLost(message: final message):
          _goToLogin(context, message);
      }
    default:
  }
}

void _handleSendFriendRequestStateChanged(
  BuildContext context,
  ParallelLoaderState<AuthReq<UserExploreWithPicture>,
          AuthResOrLost<HttpResponse<FriendshipResponse>>>
      loaderState,
  GetUserSuccess getUserSuccess,
) {
  switch (loaderState) {
    case ParallelLoadedState(data: final response, req: final req):
      switch (response) {
        case AuthRes(data: final data):
          switch (data) {
            case HttpResponseSuccess(data: final data):
              switch (data) {
                case FriendRequest(
                    id: final id,
                    sender: final sender,
                    receiver: final receiver,
                    createdAt: final createdAt,
                  ):
                  StyledBanner.show(
                    message: 'Friend request sent',
                    error: false,
                  );
                  context.userBloc.add(LoaderSetEvent(AuthRes(HttpResponseOk(
                      getUserSuccess.copyWith(
                        sentFriendRequests: getUserSuccess.sentFriendRequests
                          ..add(FriendRequestWithProfilePicture(
                            id: id,
                            sender: sender,
                            receiver: receiver,
                            createdAt: createdAt,
                            profilePicture: req.data.profilePicture,
                          )),
                      ),
                      null))));
                  context.navBarBloc.add(const NavBarSetLoadingEvent(false));
                case FriendWithoutMessage(
                    id: final id,
                    sender: final sender,
                    receiver: final receiver,
                    createdAt: final createdAt,
                    acceptedAt: final acceptedAt,
                  ):
                  StyledBanner.show(
                    message: 'Friend request accepted',
                    error: false,
                  );
                  context.userBloc.add(LoaderSetEvent(AuthRes(HttpResponseOk(
                      getUserSuccess.copyWith(
                        receivedFriendRequests: getUserSuccess
                            .receivedFriendRequests
                          ..removeWhere((request) => request.sender.id == id),
                        friendships: getUserSuccess.friendships
                          ..add(FriendWithoutMessageWithProfilePicture(
                            id: id,
                            sender: sender,
                            receiver: receiver,
                            createdAt: createdAt,
                            acceptedAt: acceptedAt,
                            profilePicture: req.data.profilePicture,
                          )),
                      ),
                      null))));
                  context.navBarBloc.add(const NavBarReverseEvent());
              }
            case HttpResponseFailure(failure: final failure):
              StyledBanner.show(
                message: failure.message,
                error: true,
              );
              context.userBloc.add(LoaderSetEvent(AuthRes(HttpResponseOk(
                  getUserSuccess.copyWith(
                      exploreUsers: getUserSuccess.exploreUsers..add(req.data)),
                  null))));
              context.navBarBloc.add(const NavBarSetLoadingEvent(false));
            default:
          }
        case AuthLost():
          _goToLogin(context, null);
        default:
      }
    default:
  }
}
