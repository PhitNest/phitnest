part of 'friend_request.dart';

final class FriendRequestPageState extends Equatable {
  final List<FriendWithoutMessageWithProfilePicture> friends;
  final List<FriendRequestWithProfilePicture> requests;
  final List<UserExploreWithPicture> exploreUsers;

  const FriendRequestPageState({
    required this.friends,
    required this.requests,
    required this.exploreUsers,
  }) : super();

  @override
  List<Object?> get props => [friends, requests, exploreUsers];
}

sealed class FriendRequestPageEvent extends Equatable {
  const FriendRequestPageEvent() : super();
}

final class FriendAddedEvent extends FriendRequestPageEvent {
  final FriendWithoutMessageWithProfilePicture friend;

  const FriendAddedEvent(this.friend) : super();

  @override
  List<Object?> get props => [friend];
}

void _handleFriendRequestPageStateChanged(
  BuildContext context,
  FriendRequestPageState state,
) {}

final class FriendRequestPageBloc
    extends Bloc<FriendRequestPageEvent, FriendRequestPageState> {
  FriendRequestPageBloc({
    required List<FriendWithoutMessageWithProfilePicture> initialFriends,
    required List<FriendRequestWithProfilePicture> initialReceivedRequests,
    required List<UserExploreWithPicture> initialExploreUsers,
  }) : super(FriendRequestPageState(
          friends: initialFriends,
          requests: initialReceivedRequests,
          exploreUsers: initialExploreUsers,
        )) {
    on<FriendAddedEvent>(
      (event, emit) {
        emit(FriendRequestPageState(
          friends: state.friends..add(event.friend),
          requests: state.requests
            ..removeWhere(
                (request) => request.sender.id == event.friend.sender.id),
          exploreUsers: state.exploreUsers
            ..removeWhere((user) => user.user.id == event.friend.sender.id),
        ));
      },
    );
  }
}

extension on BuildContext {
  FriendRequestPageBloc get friendRequestPageBloc =>
      BlocProvider.of<FriendRequestPageBloc>(this);
}

void _handleSendFriendRequestStateChanged(
  BuildContext context,
  ParallelLoaderState<AuthReq<UserExploreWithPicture>,
          AuthResOrLost<HttpResponse<FriendshipResponse>>>
      loaderState,
) {
  switch (loaderState) {
    case ParallelLoadedState(data: final response, req: final req):
      switch (response) {
        case AuthRes(data: final response):
          switch (response) {
            case HttpResponseSuccess(data: final response):
              switch (response) {
                case FriendWithoutMessage():
                  StyledBanner.show(
                    message: 'Friend added',
                    error: false,
                  );
                  context.friendRequestPageBloc.add(
                      FriendAddedEvent(FriendWithoutMessageWithProfilePicture(
                    id: response.id,
                    sender: response.sender,
                    receiver: response.receiver,
                    createdAt: response.createdAt,
                    acceptedAt: response.acceptedAt,
                    profilePicture: req.data.profilePicture,
                  )));
                case FriendRequest():
                  StyledBanner.show(
                    message: 'Friend request sent',
                    error: false,
                  );
              }
            case HttpResponseFailure(failure: final failure):
              StyledBanner.show(
                message: failure.message,
                error: true,
              );
          }
        case AuthLost(message: final message):
          StyledBanner.show(
            message: message,
            error: true,
          );
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute<void>(
              builder: (_) => const LoginPage(),
            ),
            (_) => false,
          );
      }
  }
}
