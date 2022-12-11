import 'package:dartz/dartz.dart';

import '../../../entities/entities.dart';
import '../state.dart';

class ConversationsState extends ScreenState {
  List<Tuple2<PublicUserEntity, DirectMessageEntity>> _conversations = [
    Tuple2(
      PublicUserEntity(
        id: '1',
        cognitoId: '1',
        firstName: 'John',
        lastName: 'S.',
        gymId: '1',
      ),
      DirectMessageEntity(
        id: "1",
        text: "Hello",
        conversationId: "1",
        userCognitoId: "1",
        createdAt: DateTime.now(),
      ),
    ),
    Tuple2(
      PublicUserEntity(
        id: '2',
        cognitoId: '2',
        firstName: 'Priscilla',
        lastName: 'H.',
        gymId: '1',
      ),
      DirectMessageEntity(
        id: "2",
        text:
            "Hello friend how are you doing today, I am going on vacation tomorrow to Egypt. Do you have plans this week?",
        conversationId: "2",
        userCognitoId: "2",
        createdAt: DateTime.now(),
      ),
    ),
    Tuple2(
      PublicUserEntity(
        id: '3',
        cognitoId: '3',
        firstName: 'Turner',
        lastName: 'W.',
        gymId: '1',
      ),
      DirectMessageEntity(
        id: "3",
        text:
            "Hello friend how are you doing today, I am going on vacation tomorrow to Peru. Do you have plans this week?",
        conversationId: "3",
        userCognitoId: "3",
        createdAt: DateTime.now(),
      ),
    ),
    Tuple2(
      PublicUserEntity(
        id: '1',
        cognitoId: '1',
        firstName: 'John',
        lastName: 'S.',
        gymId: '1',
      ),
      DirectMessageEntity(
        id: "1",
        text: "Hello",
        conversationId: "1",
        userCognitoId: "1",
        createdAt: DateTime.now(),
      ),
    ),
    Tuple2(
      PublicUserEntity(
        id: '2',
        cognitoId: '2',
        firstName: 'Priscilla',
        lastName: 'H.',
        gymId: '1',
      ),
      DirectMessageEntity(
        id: "2",
        text:
            "Hello friend how are you doing today, I am going on vacation tomorrow to Egypt. Do you have plans this week?",
        conversationId: "2",
        userCognitoId: "2",
        createdAt: DateTime.now(),
      ),
    ),
    Tuple2(
      PublicUserEntity(
        id: '3',
        cognitoId: '3',
        firstName: 'Turner',
        lastName: 'W.',
        gymId: '1',
      ),
      DirectMessageEntity(
        id: "3",
        text:
            "Hello friend how are you doing today, I am going on vacation tomorrow to Peru. Do you have plans this week?",
        conversationId: "3",
        userCognitoId: "3",
        createdAt: DateTime.now(),
      ),
    ),
  ];

  List<Tuple2<PublicUserEntity, DirectMessageEntity>> get conversations =>
      _conversations;

  set conversations(
      List<Tuple2<PublicUserEntity, DirectMessageEntity>> conversations) {
    _conversations = conversations;
    rebuildView();
  }

  void removeConversation(int index) {
    _conversations.removeAt(index);
    rebuildView();
  }
}
