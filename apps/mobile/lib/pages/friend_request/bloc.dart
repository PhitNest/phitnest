part of 'friend_request.dart';

typedef DeleteFriendshipBloc
    = AuthParallelLoaderBloc<(FriendshipResponse, Image), HttpResponse<void>>;
typedef DeleteFriendshipConsumer = AuthParallelLoaderConsumer<
    (FriendshipResponse, Image), HttpResponse<void>>;

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

final class FriendRemovedEvent extends FriendRequestPageEvent {
  final FriendWithoutMessageWithProfilePicture friend;

  const FriendRemovedEvent(this.friend) : super();

  @override
  List<Object?> get props => [friend];
}

final class FriendRequestDeniedEvent extends FriendRequestPageEvent {
  final FriendRequestWithProfilePicture request;

  const FriendRequestDeniedEvent(this.request) : super();

  @override
  List<Object?> get props => [request];
}

void _handleFriendRequestPageStateChanged(
  BuildContext context,
  FriendRequestPageState state,
) {}

final class FriendRequestPageBloc
    extends Bloc<FriendRequestPageEvent, FriendRequestPageState> {
  FriendRequestPageBloc({
    required String userId,
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

    on<FriendRemovedEvent>(
      (event, emit) {
        emit(FriendRequestPageState(
            friends: state.friends..remove(event.friend),
            requests: state.requests,
            exploreUsers: state.exploreUsers
              ..add(UserExploreWithPicture(
                user: event.friend.other(userId),
                profilePicture: event.friend.profilePicture,
              ))));
      },
    );

    on<FriendRequestDeniedEvent>(
      (event, emit) {
        emit(
          FriendRequestPageState(
            friends: state.friends,
            requests: state.requests..remove(event.request),
            exploreUsers: state.exploreUsers,
          ),
        );
      },
    );
  }
}

typedef FriendRequestPageConsumer
    = BlocConsumer<FriendRequestPageBloc, FriendRequestPageState>;

extension on BuildContext {
  FriendRequestPageBloc get friendRequestPageBloc =>
      BlocProvider.of<FriendRequestPageBloc>(this);
  DeleteFriendshipBloc get deleteFriendshipBloc => authParallelBloc();
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

void _handleDeleteFriendshipStateChanged(
  BuildContext context,
  ParallelLoaderState<AuthReq<(FriendshipResponse, Image)>,
          AuthResOrLost<HttpResponse<void>>>
      loaderState,
) {
  switch (loaderState) {
    case ParallelLoadedState(data: final response, req: final req):
      switch (response) {
        case AuthRes(data: final response):
          switch (response) {
            case HttpResponseSuccess():
              switch (req.data.$1) {
                case FriendWithoutMessage(
                    id: final id,
                    sender: final sender,
                    receiver: final receiver,
                    createdAt: final createdAt,
                    acceptedAt: final acceptedAt,
                  ):
                  StyledBanner.show(
                    message: 'Friend removed',
                    error: false,
                  );
                  context.friendRequestPageBloc.add(
                      FriendRemovedEvent(FriendWithoutMessageWithProfilePicture(
                    id: id,
                    sender: sender,
                    receiver: receiver,
                    createdAt: createdAt,
                    acceptedAt: acceptedAt,
                    profilePicture: req.data.$2,
                  )));
                case FriendRequest(
                    id: final id,
                    sender: final sender,
                    receiver: final receiver,
                    createdAt: final createdAt,
                  ):
                  StyledBanner.show(
                    message: 'Friend request denied',
                    error: false,
                  );
                  context.friendRequestPageBloc.add(
                      FriendRequestDeniedEvent(FriendRequestWithProfilePicture(
                    id: id,
                    sender: sender,
                    receiver: receiver,
                    createdAt: createdAt,
                    profilePicture: req.data.$2,
                  )));
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
