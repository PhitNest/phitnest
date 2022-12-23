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

  const LoadedState(this.conversations) : super();

  @override
  List<Object> get props => [conversations];
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
  ) =>
      setState(LoadedState(conversations));

  void transitionToNoConversations() => setState(const NoConversationsState());

  void addConversation(
      Either<FriendEntity, Tuple2<ConversationEntity, MessageEntity>>
          conversation) {
    final loadedState = state as LoadedState;
    setState(
      LoadedState(
        loadedState.conversations..insert(0, conversation),
      ),
    );
  }

  void removeConversation(int conversationIndex) {
    final loadedState = state as LoadedState;
    setState(
      LoadedState(
        loadedState.conversations..removeAt(conversationIndex),
      ),
    );
  }
}
