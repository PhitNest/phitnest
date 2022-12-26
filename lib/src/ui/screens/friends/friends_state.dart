import 'dart:async';

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

abstract class LoadedState extends FriendsState {
  final List<FriendEntity> friends;
  final List<PublicUserEntity> requests;
  final String searchQuery;
  final StreamSubscription<PublicUserEntity> friendRequestStream;

  const LoadedState({
    required this.friends,
    required this.requests,
    required this.searchQuery,
    required this.friendRequestStream,
  }) : super();

  @override
  List<Object> get props =>
      [friends, requests, searchQuery, friendRequestStream];
}

class NotTypingState extends LoadedState {
  const NotTypingState({
    required super.friends,
    required super.requests,
    required super.searchQuery,
    required super.friendRequestStream,
  });
}

class TypingState extends LoadedState {
  const TypingState({
    required super.friends,
    required super.requests,
    required super.searchQuery,
    required super.friendRequestStream,
  });
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
    required StreamSubscription<PublicUserEntity> friendRequestStream,
  }) =>
      setState(
        NotTypingState(
          friends: friends,
          requests: requests,
          searchQuery: searchQuery,
          friendRequestStream: friendRequestStream,
        ),
      );

  void transitionStopTyping() {
    final typingState = state as TypingState;
    setState(
      NotTypingState(
        friends: typingState.friends,
        requests: typingState.requests,
        searchQuery: typingState.searchQuery,
        friendRequestStream: typingState.friendRequestStream,
      ),
    );
  }

  void transitionToTyping() {
    final notTypingState = state as NotTypingState;
    setState(
      TypingState(
        friends: notTypingState.friends,
        requests: notTypingState.requests,
        searchQuery: notTypingState.searchQuery,
        friendRequestStream: notTypingState.friendRequestStream,
      ),
    );
  }

  void setSearchQuery(String searchQuery) {
    final typingState = state as TypingState;
    setState(
      TypingState(
        friends: typingState.friends,
        requests: typingState.requests,
        searchQuery: searchQuery,
        friendRequestStream: typingState.friendRequestStream,
      ),
    );
  }

  void removeFriend(int index) {
    if (state is NotTypingState) {
      final notTypingState = state as NotTypingState;
      setState(
        NotTypingState(
          friends: List.from(notTypingState.friends)..removeAt(index),
          requests: notTypingState.requests,
          searchQuery: notTypingState.searchQuery,
          friendRequestStream: notTypingState.friendRequestStream,
        ),
      );
    } else if (state is TypingState) {
      final typingState = state as TypingState;
      setState(
        TypingState(
          friends: List.from(typingState.friends)..removeAt(index),
          requests: typingState.requests,
          searchQuery: typingState.searchQuery,
          friendRequestStream: typingState.friendRequestStream,
        ),
      );
    }
  }

  void removeRequest(int index) {
    if (state is NotTypingState) {
      final notTypingState = state as NotTypingState;
      setState(
        NotTypingState(
          friends: notTypingState.friends,
          requests: List.from(notTypingState.requests)..removeAt(index),
          searchQuery: notTypingState.searchQuery,
          friendRequestStream: notTypingState.friendRequestStream,
        ),
      );
    } else if (state is TypingState) {
      final typingState = state as TypingState;
      setState(
        TypingState(
          friends: typingState.friends,
          requests: List.from(typingState.requests)..removeAt(index),
          searchQuery: typingState.searchQuery,
          friendRequestStream: typingState.friendRequestStream,
        ),
      );
    }
  }

  void addFriend(FriendEntity friend) {
    if (state is NotTypingState) {
      final notTypingState = state as NotTypingState;
      setState(
        NotTypingState(
          friends: List.from(notTypingState.friends)..insert(0, friend),
          requests: notTypingState.requests,
          searchQuery: notTypingState.searchQuery,
          friendRequestStream: notTypingState.friendRequestStream,
        ),
      );
    } else if (state is TypingState) {
      final typingState = state as TypingState;
      setState(
        TypingState(
          friends: List.from(typingState.friends)..insert(0, friend),
          requests: typingState.requests,
          searchQuery: typingState.searchQuery,
          friendRequestStream: typingState.friendRequestStream,
        ),
      );
    }
  }

  void addRequest(PublicUserEntity request) {
    if (state is NotTypingState) {
      final notTypingState = state as NotTypingState;
      setState(
        NotTypingState(
          friends: notTypingState.friends,
          requests: List.from(notTypingState.requests)..insert(0, request),
          searchQuery: notTypingState.searchQuery,
          friendRequestStream: notTypingState.friendRequestStream,
        ),
      );
    } else if (state is TypingState) {
      final typingState = state as TypingState;
      setState(
        TypingState(
          friends: typingState.friends,
          requests: List.from(typingState.requests)..insert(0, request),
          searchQuery: typingState.searchQuery,
          friendRequestStream: typingState.friendRequestStream,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    if (state is LoadedState) {
      final loadedState = state as LoadedState;
      loadedState.friendRequestStream.cancel();
    }
    return super.close();
  }
}
