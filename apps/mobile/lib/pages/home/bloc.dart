part of 'home.dart';

typedef SendFriendRequestBloc = AuthLoaderBloc<UserExploreWithPicture,
    (UserExploreWithPicture, HttpResponse<FriendshipResponse>)>;
typedef SendFriendRequestConsumer = AuthLoaderConsumer<UserExploreWithPicture,
    (UserExploreWithPicture, HttpResponse<FriendshipResponse>)>;

typedef DeleteUserBloc = AuthLoaderBloc<void, HttpResponse<bool>>;
typedef DeleteUserConsumer = AuthLoaderConsumer<void, HttpResponse<bool>>;

typedef UserBloc = AuthLoaderBloc<void, HttpResponse<GetUserResponse>>;
typedef UserConsumer = AuthLoaderConsumer<void, HttpResponse<GetUserResponse>>;

extension HomeBlocGetters on BuildContext {
  UserBloc get userBloc => authLoader();
  SendFriendRequestBloc get sendFriendRequestBloc => authLoader();
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

void _handleGetUserStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<HttpResponse<GetUserResponse>>> loaderState,
  NavBarState navBarState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case AuthRes(data: final response):
          switch (response) {
            case HttpResponseSuccess(data: final response):
              switch (response) {
                case GetUserSuccess(exploreUsers: final exploreUsers):
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute<void>(
                      builder: (_) => const PhotoInstructionsPage(),
                    ),
                    (_) => false,
                  );
                default:
              }
            case HttpResponseFailure(failure: final failure):
              StyledBanner.show(
                message: failure.message,
                error: true,
              );
              context.userBloc
                  .add(LoaderLoadEvent(AuthReq(null, context.sessionLoader)));
          }
        case AuthLost(message: final message):
          _goToLogin(context, message);
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
  LoaderState<
          AuthResOrLost<
              (UserExploreWithPicture, HttpResponse<FriendshipResponse>)>>
      loaderState,
  GetUserSuccess getUserSuccess,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case AuthRes(data: final data):
          switch (data.$2) {
            case HttpResponseSuccess(data: final data):
              switch (data) {
                case FriendRequest():
                  StyledBanner.show(
                    message: 'Friend request sent',
                    error: false,
                  );
                  context.userBloc.add(LoaderSetEvent(AuthRes(HttpResponseOk(
                      getUserSuccess.copyWith(
                        sentFriendRequests: getUserSuccess.sentFriendRequests
                          ..add(data),
                      ),
                      null))));
                  context.navBarBloc.add(const NavBarSetLoadingEvent(false));
                case FriendshipWithoutMessage():
                  StyledBanner.show(
                    message: 'Friend request accepted',
                    error: false,
                  );
                  context.userBloc.add(LoaderSetEvent(AuthRes(HttpResponseOk(
                      getUserSuccess.copyWith(
                        friendships: getUserSuccess.friendships..add(data),
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
                      exploreUsers: getUserSuccess.exploreUsers..add(data.$1)),
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
