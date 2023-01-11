import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../entities/entities.dart';
import '../screen_state.dart';

abstract class ConversationsState extends ScreenState {
  const ConversationsState() : super();
}

class LoadingState extends ConversationsState {
  const LoadingState() : super();
}

class ErrorState extends ConversationsState {
  final String message;

  const ErrorState(this.message) : super();

  @override
  List<Object> get props => [message];
}

class LoadedState extends ConversationsState {
  final List<Either<FriendEntity, Tuple2<ConversationEntity, MessageEntity>>>
      conversations;
  final StreamSubscription<MessageEntity> messageSubscription;
  final StreamSubscription<Tuple2<ConversationEntity, MessageEntity>>
      newConversationSubscription;

  const LoadedState(
    this.conversations,
    this.messageSubscription,
    this.newConversationSubscription,
  ) : super();

  @override
  Future<void> dispose() {
    messageSubscription.cancel();
    newConversationSubscription.cancel();
    return super.dispose();
  }

  @override
  List<Object> get props =>
      [conversations, messageSubscription, newConversationSubscription];
}

class NoConversationsState extends ConversationsState {
  const NoConversationsState() : super();
}

class ConversationsCubit extends ScreenCubit<ConversationsState> {
  ConversationsCubit() : super(const LoadingState());

  void transitionToLoading() => setState(const LoadingState());

  void transitionToError(String message) => setState(ErrorState(message));

  void transitionToLoaded(
    List<Either<FriendEntity, Tuple2<ConversationEntity, MessageEntity>>>
        conversations,
    StreamSubscription<MessageEntity> messageSubscription,
    StreamSubscription<Tuple2<ConversationEntity, MessageEntity>>
        newConversationSubscription,
  ) =>
      setState(LoadedState(
        conversations,
        messageSubscription,
        newConversationSubscription,
      ));

  void transitionToNoConversations() => setState(const NoConversationsState());

  void addNewConversation(
    Tuple2<ConversationEntity, MessageEntity> newConversation,
  ) {
    final loadedState = state as LoadedState;
    final conversationIndex = loadedState.conversations.indexWhere(
      (conversation) => conversation.fold(
        (friend) => friend.cognitoId == newConversation.value2.userCognitoId,
        (conversation) => false,
      ),
    );
    if (conversationIndex != -1) {
      loadedState.conversations.removeAt(conversationIndex);
    }
    setState(
      LoadedState(
        List.from(loadedState.conversations)..insert(0, Right(newConversation)),
        loadedState.messageSubscription,
        loadedState.newConversationSubscription,
      ),
    );
  }

  void updateExistingConversation(
    MessageEntity message,
  ) {
    final loadedState = state as LoadedState;
    final conversationIndex = loadedState.conversations.indexWhere(
      (conversation) => conversation.fold(
        (friend) => false,
        (conversation) => conversation.value1.id == message.conversationId,
      ),
    );
    final conversation = loadedState.conversations[conversationIndex].fold(
      (friend) => throw Exception('Cannot update a non-existing conversation'),
      (conversation) => Tuple2(
        conversation.value1,
        message,
      ),
    );
    setState(
      LoadedState(
        List.from(loadedState.conversations)
          ..removeAt(conversationIndex)
          ..insert(0, Right(conversation)),
        loadedState.messageSubscription,
        loadedState.newConversationSubscription,
      ),
    );
  }
}
