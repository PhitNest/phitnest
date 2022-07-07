import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../api.dart';

/// Firebase implementation of the social api.
class FirebaseSocialApi extends SocialApi {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<String?> updateFullUserModel(UserModel user) async {
    try {
      await firestore
          .collection(kUsersPublic)
          .doc(user.userId)
          .update(user.toPublicJson());
      await firestore
          .collection(kUsersPrivate)
          .doc(user.userId)
          .update(user.toPrivateJson());
      return null;
    } catch (e) {
      return '$e';
    }
  }

  @override
  Stream<UserPublicInfo?> streamUserInfo(String uid) => firestore
      .collection(kUsersPublic)
      .doc(uid)
      .snapshots()
      .map((doc) => doc.exists ? UserPublicInfo.fromJson(doc.data()!) : null);

  @override
  Future<UserModel?> getFullUserModel(String uid) async {
    UserPublicInfo? userPublic;
    UserPrivateInfo? userPrivate;

    await Future.wait([
      streamUserInfo(uid).first.then((user) => userPublic = user),
      firestore.collection(kUsersPrivate).doc(uid).get().then((json) =>
          userPrivate =
              json.exists ? UserPrivateInfo.fromJson(json.data()!) : null),
    ]);

    return userPublic != null && userPrivate != null
        ? UserModel.fromInfo(publicInfo: userPublic!, privateInfo: userPrivate!)
        : null;
  }

  Stream<List<ChatMessage>> streamMessagesBetweenUsers(
      String userId, String otherUserId,
      {int quantity = 1, bool descending = true}) async* {
    StreamController<List<ChatMessage>> streamController =
        StreamController<List<ChatMessage>>();
    List<ChatMessage> sent = [];
    List<ChatMessage> received = [];

    List<ChatMessage> getSorted(
            List<ChatMessage> sent, List<ChatMessage> received) =>
        (sent + received)
            .sublist(0, min(quantity, sent.length + received.length))
          ..sort((a, b) => a.compareTimeStamps(b));

    firestore
        .collection('direct_messages')
        .where('authorId', isEqualTo: userId)
        .where('recipientId', isEqualTo: otherUserId)
        .orderBy('timeStamp', descending: descending)
        .limit(quantity)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromJson(doc.data()))
            .toList())
        .listen((messages) {
      sent = messages;
      streamController.sink.add(getSorted(sent, received));
    });

    firestore
        .collection('direct_messages')
        .where('authorId', isEqualTo: otherUserId)
        .where('recipientId', isEqualTo: userId)
        .orderBy('timeStamp', descending: descending)
        .limit(quantity)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromJson(doc.data()))
            .toList())
        .listen((messages) {
      received = messages;
      streamController.sink.add(getSorted(sent, received));
    });

    yield* streamController.stream;
  }

  Stream<List<UserPublicInfo>> streamFriends(String userId,
          {int quantity = 1,
          String orderBy = 'timeStamp',
          bool descending = true}) =>
      firestore
          .collection('relations')
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: 'friend')
          .orderBy(orderBy, descending: descending)
          .limit(quantity)
          .snapshots()
          .asyncMap((snapshot) => Future.wait(snapshot.docs.map((doc) =>
              api<SocialApi>()
                  .streamUserInfo(Relation.fromJson(doc.data()).targetId)
                  .first
                  .then((value) => value!))));

  Stream<Map<UserPublicInfo, ChatMessage>> streamRecentMessagesFromFriends(
    String userId, {
    int quantity = 1,
    bool descending = true,
  }) {
    StreamController<Map<UserPublicInfo, ChatMessage>> streamController =
        StreamController<Map<UserPublicInfo, ChatMessage>>();

    Map<String, StreamSubscription<UserPublicInfo?>> userSubscriptionMap = {};
    Map<String, StreamSubscription<ChatMessage>> messageSubscriptionMap = {};
    Map<UserPublicInfo, ChatMessage> messageMap = {};

    streamFriends(userId, quantity: quantity, descending: descending)
        .listen((friends) async {
      userSubscriptionMap.forEach((key, value) => value.cancel());
      messageSubscriptionMap.forEach((key, value) => value.cancel());
      userSubscriptionMap.clear();
      messageSubscriptionMap.clear();
      messageMap.clear();
      for (UserPublicInfo friend in friends) {
        messageSubscriptionMap[friend.userId] = streamMessagesBetweenUsers(
                userId, friend.userId,
                descending: descending)
            .asyncMap((messages) => messages.first)
            .listen((message) {
          messageMap[friend] = message;
          streamController.sink.add(messageMap);
        });

        userSubscriptionMap[friend.userId] =
            streamUserInfo(friend.userId).listen((newData) {
          for (UserPublicInfo userInfo in messageMap.keys) {
            if (userInfo.userId == friend.userId) {
              if (newData != null) {
                messageMap[newData] = messageMap[userInfo]!;
              }
              messageMap.remove(userInfo);
              streamController.sink.add(messageMap);
              return;
            }
          }
        });
      }

      streamController.sink.add(messageMap);
    });

    return streamController.stream;
  }

  @override
  Future<void> updateReadStatus(String messageId, {bool read = true}) async =>
      firestore
          .collection('direct_messages')
          .doc(messageId)
          .update({'read': true});
}
