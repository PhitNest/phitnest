import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../entities/entities.dart';
import '../screen_state.dart';

abstract class MessageState extends ScreenState {
  const MessageState() : super();
}

class InitialState extends MessageState {
  const InitialState() : super();
}

class NewFriendState extends MessageState {
  final FriendEntity friend;
  final StreamSubscription<Tuple2<ConversationEntity, MessageEntity>> stream;

  const NewFriendState({
    required this.friend,
    required this.stream,
  }) : super();

  @override
  List<Object> get props => [friend, stream];

  @override
  Future<void> dispose() {
    stream.cancel();
    return super.dispose();
  }
}

class LoadingNewFriendState extends MessageState {
  final FriendEntity friend;

  const LoadingNewFriendState({
    required this.friend,
  }) : super();

  @override
  List<Object> get props => [friend];
}

class LoadingConversationState extends MessageState {
  final ConversationEntity conversation;

  const LoadingConversationState({
    required this.conversation,
  }) : super();

  @override
  List<Object> get props => [conversation];
}

class ErrorState extends MessageState {
  final String message;

  const ErrorState({
    required this.message,
  }) : super();

  @override
  List<Object> get props => [message];
}

class LoadedState extends MessageState {
  final ConversationEntity conversation;
  final List<MessageEntity> messages;
  final StreamSubscription<MessageEntity> messageStream;

  const LoadedState({
    required this.conversation,
    required this.messages,
    required this.messageStream,
  }) : super();

  @override
  List<Object> get props => [conversation, messages, messageStream];

  @override
  Future<void> dispose() {
    messageStream.cancel();
    return super.dispose();
  }
}

class MessageCubit extends ScreenCubit<MessageState> {
  MessageCubit() : super(const InitialState());

  void transitionToLoadingNewFriend(FriendEntity friend) =>
      setState(LoadingNewFriendState(friend: friend));

  void transitionToNewFriend(
          StreamSubscription<Tuple2<ConversationEntity, MessageEntity>>
              stream) =>
      setState(
        NewFriendState(
          friend: (state as LoadingNewFriendState).friend,
          stream: stream,
        ),
      );

  void transitionToLoadingConversation(ConversationEntity conversation) =>
      setState(LoadingConversationState(conversation: conversation));

  void transitionToLoaded(
    ConversationEntity conversation,
    List<MessageEntity> messages,
    StreamSubscription<MessageEntity> messageStream,
  ) {
    if (state is NewFriendState) {
      final newFriendState = state as NewFriendState;
      newFriendState.stream.cancel();
    }
    setState(
      LoadedState(
        conversation: conversation,
        messages: messages,
        messageStream: messageStream,
      ),
    );
  }

  void transitionToError(String message) {
    if (state is NewFriendState) {
      final newFriendState = state as NewFriendState;
      newFriendState.stream.cancel();
    } else if (state is LoadedState) {
      final loadedState = state as LoadedState;
      loadedState.messageStream.cancel();
    }
    setState(ErrorState(message: message));
  }

  void addMessage(MessageEntity newMessage) {
    final loadedState = state as LoadedState;
    setState(
      LoadedState(
        conversation: loadedState.conversation,
        messages: [newMessage, ...loadedState.messages],
        messageStream: loadedState.messageStream,
      ),
    );
  }
}
