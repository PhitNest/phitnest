part of 'home.dart';

typedef SendFriendRequestBloc
    = AuthLoaderBloc<String, HttpResponse<FriendshipResponse>>;
typedef SendFriendRequestConsumer
    = AuthLoaderConsumer<String, HttpResponse<FriendshipResponse>>;

typedef UserBloc = AuthLoaderBloc<void, HttpResponse<GetUserResponse>>;
typedef UserConsumer = AuthLoaderConsumer<void, HttpResponse<GetUserResponse>>;

extension HomeBlocGetters on BuildContext {
  UserBloc get userBloc => authLoader();
  SendFriendRequestBloc get sendFriendRequestBloc => authLoader();
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
                case GetUserSuccess(exploreWithPictures: final exploreUsers):
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

void _handleSendFriendRequestStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<HttpResponse<FriendshipResponse>>> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case AuthRes(data: final data):
          switch (data) {
            case HttpResponseSuccess(data: final data):
              switch (data) {
                case FriendRequest():
                  StyledBanner.show(
                    message: 'Friend request sent',
                    error: false,
                  );
                  context.navBarBloc.add(const NavBarSetLoadingEvent(false));
                case FriendshipWithoutMessage():
                  StyledBanner.show(
                    message: 'Friend request accepted',
                    error: false,
                  );
                  context.navBarBloc.add(const NavBarReverseEvent());
              }
            case HttpResponseFailure(failure: final failure):
              StyledBanner.show(
                message: failure.message,
                error: true,
              );
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
