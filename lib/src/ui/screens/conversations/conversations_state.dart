import 'package:dartz/dartz.dart';

import '../../../entities/entities.dart';
import '../state.dart';

class ConversationsState extends ScreenState {
  String? userId;

  List<Tuple3<PublicUserEntity, MessageEntity, bool>> _conversations = [
    Tuple3(
        PublicUserEntity(
          id: '1',
          cognitoId: '1',
          firstName: 'John',
          lastName: 'S.',
          gymId: '1',
        ),
        MessageEntity(
          text: "Hello",
          conversationId: "1",
          userCognitoId: "1",
        ),
        false),
    Tuple3(
        PublicUserEntity(
          id: '2',
          cognitoId: '2',
          firstName: 'Priscilla',
          lastName: 'H.',
          gymId: '1',
        ),
        MessageEntity(
          text:
              "Hello friend how are you doing today, I am going on vacation tomorrow to Egypt. Do you have plans this week?",
          conversationId: "2",
          userCognitoId: "2",
        ),
        false),
    Tuple3(
        PublicUserEntity(
          id: '3',
          cognitoId: '3',
          firstName: 'Turner',
          lastName: 'W.',
          gymId: '1',
        ),
        MessageEntity(
          text:
              "Hello friend how are you doing today, I am going on vacation tomorrow to Peru. Do you have plans this week?",
          conversationId: "3",
          userCognitoId: "3",
        ),
        false),
    Tuple3(
        PublicUserEntity(
          id: '1',
          cognitoId: '1',
          firstName: 'John',
          lastName: 'S.',
          gymId: '1',
        ),
        MessageEntity(
          text: "Hello",
          conversationId: "1",
          userCognitoId: "1",
        ),
        false),
    Tuple3(
        PublicUserEntity(
          id: '2',
          cognitoId: '2',
          firstName: 'Priscilla',
          lastName: 'H.',
          gymId: '1',
        ),
        MessageEntity(
          text:
              "Hello friend how are you doing today, I am going on vacation tomorrow to Egypt. Do you have plans this week?",
          conversationId: "2",
          userCognitoId: "2",
        ),
        false),
    Tuple3(
        PublicUserEntity(
          id: '3',
          cognitoId: '3',
          firstName: 'Turner',
          lastName: 'W.',
          gymId: '1',
        ),
        MessageEntity(
          text:
              "Hello friend how are you doing today, I am going on vacation tomorrow to Peru. Do you have plans this week?",
          conversationId: "3",
          userCognitoId: "3",
        ),
        false),
  ];

  List<Tuple3<PublicUserEntity, MessageEntity, bool>> get conversations =>
      _conversations;

  set conversations(
      List<Tuple3<PublicUserEntity, MessageEntity, bool>> conversations) {
    _conversations = conversations;
    rebuildView();
  }

  void selectConversation(int index, bool isSelected) {
    _conversations[index] = Tuple3(
      _conversations[index].value1,
      _conversations[index].value2,
      isSelected,
    );
    rebuildView();
  }
}
