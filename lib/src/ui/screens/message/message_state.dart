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

  const NewFriendState({
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

  const LoadedState({
    required this.conversation,
    required this.messages,
  }) : super();

  @override
  List<Object> get props => [conversation, messages];
}

class MessageCubit extends ScreenCubit<MessageState> {
  MessageCubit() : super(const InitialState());

  void transitionToNewFriend(FriendEntity friend) =>
      setState(NewFriendState(friend: friend));

  void transitionToLoading(ConversationEntity conversation) =>
      setState(LoadingConversationState(conversation: conversation));

  void transitionToLoaded(
          ConversationEntity conversation, List<MessageEntity> messages) =>
      setState(LoadedState(conversation: conversation, messages: messages));

  void transitionToError(String message) =>
      setState(ErrorState(message: message));

  void addMessage(MessageEntity newMessage) {
    final loadedState = state as LoadedState;
    setState(LoadedState(
        conversation: loadedState.conversation,
        messages: [newMessage, ...loadedState.messages]));
  }
}
