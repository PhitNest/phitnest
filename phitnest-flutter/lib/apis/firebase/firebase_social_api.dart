import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../api.dart';

class FirebaseSocialApiState extends SocialApiState {}

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
  Future<void> deleteMessage(String conversationId, String messageId) async {
    await firestore
        .collection('$kConversations/$conversationId/messages')
        .doc(messageId)
        .delete();
    try {
      ChatMessage recentMessage =
          (await streamMessages(conversationId, quantity: 1).first).first;
      await firestore
          .collection(kConversations)
          .doc(conversationId)
          .update({'timestamp': recentMessage.timestamp});
    } catch (err) {
      await deleteConversation(conversationId);
    }
  }

  @override
  Future<void> deleteConversation(String conversationId) async =>
      await Future.wait((await firestore
              .collection('$kConversations/$conversationId/messages')
              .get())
          .docs
          .map((doc) => deleteMessage(conversationId, doc.id)));

  @override
  Future<void> createConversation(List<String> userIds) async {
    var docReference = firestore.collection(kConversations).doc();

    Conversation conversation = Conversation(
        conversationId: docReference.id,
        participants: userIds,
        timestamp: DateTime.now());

    await docReference.set(conversation.toJson());
  }

  @override
  Future<void> sendMessage(
      String authorId, String conversationId, String text) async {
    var docReference =
        firestore.collection('$kConversations/$conversationId/messages').doc();

    ChatMessage message = ChatMessage(
        messageId: docReference.id,
        authorId: authorId,
        text: text,
        timestamp: DateTime.now(),
        read: false);

    await Future.wait([
      firestore
          .collection(kConversations)
          .doc(conversationId)
          .update({'timestamp': message.timestamp}),
      docReference.set(message.toJson())
    ]);
  }

  @override
  Stream<List<Conversation>> streamConversations(String userId,
      {int quantity = -1,
      String orderBy = 'timestamp',
      bool descending = true}) {
    var query = firestore
        .collection(kConversations)
        .where('participants', arrayContains: userId)
        .orderBy(orderBy, descending: descending);
    if (quantity != -1) {
      query = query.limit(quantity);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Conversation.fromJson(doc.data())).toList());
  }

  Stream<List<Relation>> streamRelations(String userId,
      {int quantity = -1,
      String orderBy = 'timestamp',
      String? type,
      bool descending = true}) {
    var query = firestore
        .collection(kRelations)
        .where('userId', isEqualTo: userId)
        .orderBy(orderBy, descending: descending);
    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }

    if (quantity != -1) {
      query = query.limit(quantity);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Relation.fromJson(doc.data())).toList());
  }

  @override
  Stream<List<UserPublicInfo>> streamFriends(String userId,
      {int quantity = -1,
      String orderBy = 'timestamp',
      bool descending = true}) {
    List<String> userIds = [];
    Map<String, StreamSubscription<UserPublicInfo>> userStream = {};
    Map<String, UserPublicInfo> userMap = {};
    late StreamSubscription<List<Relation>> relationListener;

    cancelStreams() => userStream.forEach((key, value) => value.cancel());

    StreamController<List<UserPublicInfo>> streamController =
        StreamController<List<UserPublicInfo>>(onCancel: () {
      cancelStreams();
      relationListener.cancel();
    });

    relationListener = streamRelations(userId,
            quantity: quantity,
            orderBy: orderBy,
            descending: descending,
            type: 'friend')
        .listen((friendRelations) {
      userIds.clear();
      for (Relation relation in friendRelations) {
        userIds.add(relation.targetId);
        if (!userStream.containsKey(relation.targetId)) {
          userStream[relation.targetId] = api<SocialApi>()
              .streamUserInfo(relation.targetId)
              .where((user) => user != null)
              .map((user) => user!)
              .listen((user) {
            userMap[user.userId] = user;
            streamController.sink
                .add(userIds.map((id) => userMap[id]!).toList());
          });
        }
      }
    });

    return streamController.stream;
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
      bool descending = true}) {
    var query = firestore
        .collection('$kConversations/$conversationId/$kMessages')
        .orderBy(orderBy, descending: descending);

    if (quantity != -1) {
      query = query.limit(quantity);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ChatMessage.fromJson(doc.data())).toList());
  }

  @override
  Future<AuthenticatedUser?> refreshSignedInUser() async {
    String? uid = await api<AuthenticationApi>().getAuthenticatedUid();
    if (uid != null) {
      return await streamSignedInUser(uid).first;
    }
    return null;
  }

  @override
  Stream<AuthenticatedUser> streamSignedInUser(String uid) {
    UserPublicInfo? userPublic;
    UserPrivateInfo? userPrivate;
    late StreamSubscription<UserPublicInfo?> publicListener;
    late StreamSubscription<UserPrivateInfo?> privateListener;

    StreamController<AuthenticatedUser> streamController =
        StreamController<AuthenticatedUser>(onCancel: () {
      publicListener.cancel();
      privateListener.cancel();
    });

    buildUserModel() {
      if (userPublic != null && userPrivate != null) {
        streamController.sink.add(AuthenticatedUser.fromInfo(
            publicInfo: userPublic!, privateInfo: userPrivate!));
      }
    }

    publicListener = streamUserInfo(uid).listen((publicInfo) {
      userPublic = publicInfo;
      buildUserModel();
    });

    privateListener = firestore
        .collection(kUsersPrivate)
        .doc(uid)
        .snapshots()
        .map((snapshot) => UserPrivateInfo.fromJson(snapshot.data()!))
        .listen((privateInfo) {
      userPrivate = privateInfo;
      buildUserModel();
    });

    return streamController.stream;
  }

  @override
  FirebaseSocialApiState get initState => FirebaseSocialApiState();
}
