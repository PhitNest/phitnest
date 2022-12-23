import '../../../entities/entities.dart';
import '../screen_state.dart';

abstract class FriendsState extends ScreenState {
  const FriendsState();
}

class LoadingState extends FriendsState {
  const LoadingState() : super();
}

class ErrorState extends FriendsState {
  final String message;

  const ErrorState({
    required this.message,
  }) : super();

  @override
  List<Object> get props => [message];
}

class LoadedState extends FriendsState {
  final List<FriendEntity> friends;
  final List<PublicUserEntity> requests;
  final String searchQuery;

  const LoadedState({
    required this.friends,
    required this.requests,
    required this.searchQuery,
  }) : super();

  @override
  List<Object> get props => [friends, requests, searchQuery];
}

class TypingState extends FriendsState {
  final List<FriendEntity> friends;
  final List<PublicUserEntity> requests;
  final String searchQuery;

  const TypingState({
    required this.friends,
    required this.requests,
    required this.searchQuery,
  }) : super();

  @override
  List<Object> get props => [friends, requests, searchQuery];
}

class FriendsCubit extends ScreenCubit<FriendsState> {
  FriendsCubit() : super(const LoadingState());

  void transitionToLoading() => setState(const LoadingState());

  void transitionToError(String message) =>
      setState(ErrorState(message: message));

  void transitionToLoaded({
    required List<FriendEntity> friends,
    required List<PublicUserEntity> requests,
    required String searchQuery,
  }) =>
      setState(
        LoadedState(
          friends: friends,
          requests: requests,
          searchQuery: searchQuery,
        ),
      );

  void transitionTypingToLoaded() {
    final typingState = state as TypingState;
    setState(
      LoadedState(
        friends: typingState.friends,
        requests: typingState.requests,
        searchQuery: typingState.searchQuery,
      ),
    );
  }

  void transitionToTyping() {
    final loadedState = state as LoadedState;
    setState(
      TypingState(
        friends: loadedState.friends,
        requests: loadedState.requests,
        searchQuery: loadedState.searchQuery,
      ),
    );
  }

  void setSearchQuery(String searchQuery) {
    setState(
      TypingState(
        friends: (state as TypingState).friends,
        requests: (state as TypingState).requests,
        searchQuery: searchQuery,
      ),
    );
  }

  void removeFriend(int index) {
    if (state is LoadedState) {
      final loadedState = state as LoadedState;
      setState(
        LoadedState(
          friends: List.from(loadedState.friends)..removeAt(index),
          requests: loadedState.requests,
          searchQuery: loadedState.searchQuery,
        ),
      );
    } else if (state is TypingState) {
      final typingState = state as TypingState;
      setState(
        TypingState(
          friends: List.from(typingState.friends)..removeAt(index),
          requests: typingState.requests,
          searchQuery: typingState.searchQuery,
        ),
      );
    }
  }

  void removeRequest(int index) {
    if (state is LoadedState) {
      final loadedState = state as LoadedState;
      setState(
        LoadedState(
          friends: loadedState.friends,
          requests: List.from(loadedState.requests)..removeAt(index),
          searchQuery: loadedState.searchQuery,
        ),
      );
    } else if (state is TypingState) {
      final typingState = state as TypingState;
      setState(
        TypingState(
          friends: typingState.friends,
          requests: List.from(typingState.requests)..removeAt(index),
          searchQuery: typingState.searchQuery,
        ),
      );
    }
  }

  void addFriend(FriendEntity friend) {
    if (state is LoadedState) {
      final loadedState = state as LoadedState;
      setState(
        LoadedState(
          friends: List.from(loadedState.friends)..insert(0, friend),
          requests: loadedState.requests,
          searchQuery: loadedState.searchQuery,
        ),
      );
    } else if (state is TypingState) {
      final typingState = state as TypingState;
      setState(
        TypingState(
          friends: List.from(typingState.friends)..insert(0, friend),
          requests: typingState.requests,
          searchQuery: typingState.searchQuery,
        ),
      );
    }
  }

  void addRequest(PublicUserEntity request) {
    if (state is LoadedState) {
      final loadedState = state as LoadedState;
      setState(
        LoadedState(
          friends: loadedState.friends,
          requests: List.from(loadedState.requests)..insert(0, request),
          searchQuery: loadedState.searchQuery,
        ),
      );
    } else if (state is TypingState) {
      final typingState = state as TypingState;
      setState(
        TypingState(
          friends: typingState.friends,
          requests: List.from(typingState.requests)..insert(0, request),
          searchQuery: typingState.searchQuery,
        ),
      );
    }
  }
}
