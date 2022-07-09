import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../api.dart';

/// Firebase implementation of the social api.
class FirebaseSocialApi extends SocialApi {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<String?> updateUserModel(AuthenticatedUser user) async {
    try {
      await firestore
          .collection(kUsersPublic)
          .doc(user.userId)
          .set(user.toPublicJson());
      await firestore
          .collection(kUsersPrivate)
          .doc(user.userId)
          .set(user.toPrivateJson());
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
  Stream<List<Conversation>> streamConversations(
      {int quantity = -1,
      String orderBy = 'timestamp',
      bool descending = true}) async* {
    var query = firestore
        .collection(kConversations)
        .where('participants',
            arrayContains: await api<AuthenticationApi>().getAuthenticatedUid())
        .orderBy(orderBy, descending: descending);
    if (quantity != -1) {
      query = query.limit(quantity);
    }

    yield* query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Conversation.fromJson(doc.data())).toList());
  }

  Stream<List<Relation>> streamRelations(
      {int quantity = -1,
      String orderBy = 'timestamp',
      String? type,
      bool descending = true}) async* {
    var query = firestore
        .collection(kRelations)
        .where('userId',
            isEqualTo: await api<AuthenticationApi>().getAuthenticatedUid())
        .orderBy(orderBy, descending: descending);
    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }

    if (quantity != -1) {
      query = query.limit(quantity);
    }

    yield* query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Relation.fromJson(doc.data())).toList());
  }

  @override
  Stream<List<UserPublicInfo>> streamFriends(
      {int quantity = -1,
      String orderBy = 'timestamp',
      bool descending = true}) async* {
    Map<String, UserPublicInfo> userMap = {};
    List<String> userIds = [];
    List<StreamSubscription<UserPublicInfo>> userStream = [];

    cancelStreams() => userStream.forEach((element) => element.cancel());

    StreamController<List<UserPublicInfo>> streamController =
        StreamController<List<UserPublicInfo>>(onCancel: cancelStreams);

    streamRelations(
            quantity: quantity,
            orderBy: orderBy,
            descending: descending,
            type: 'friend')
        .listen((friendRelations) async {
      userMap.clear();
      userIds.clear();
      cancelStreams();
      userStream.clear();
      for (Relation relation in friendRelations) {
        userIds.add(relation.targetId);
        userStream.add(await api<SocialApi>()
            .streamUserInfo(relation.targetId)
            .where((user) => user != null)
            .map((user) => user!)
            .listen((user) {
          userMap[user.userId] = user;
          streamController.sink.add(userIds.map((id) => userMap[id]!).toList());
        }));
      }
    });

    yield* streamController.stream;
  }

  @override
  Future<void> updateReadStatus(
          {required String conversationId,
          required String messageId,
          bool read = true}) =>
      firestore
          .collection('$kConversations/$conversationId/$kMessages')
          .doc(messageId)
          .update({'read': true});

  @override
  Stream<List<ChatMessage>> streamMessages(String conversationId,
      {int quantity = -1,
      String orderBy = 'timestamp',
      bool descending = true}) async* {
    var query = firestore
        .collection('$kConversations/$conversationId/$kMessages')
        .orderBy(orderBy, descending: descending);

    if (quantity != -1) {
      query = query.limit(quantity);
    }

    yield* query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ChatMessage.fromJson(doc.data())).toList());
  }

  @override
  Future<AuthenticatedUser?> getSignedInUser() async {
    String? uid = await api<AuthenticationApi>().getAuthenticatedUid();
    if (uid != null) {
      UserPublicInfo? userPublic;
      UserPrivateInfo? userPrivate;

      await Future.wait([
        streamUserInfo(uid).first.then((user) => userPublic = user),
        firestore.collection(kUsersPrivate).doc(uid).get().then((json) =>
            userPrivate =
                json.exists ? UserPrivateInfo.fromJson(json.data()!) : null),
      ]);

      if (userPublic != null && userPrivate != null) {
        return AuthenticatedUser.fromInfo(
            publicInfo: userPublic!, privateInfo: userPrivate!);
      }
    }
    return null;
  }
}
