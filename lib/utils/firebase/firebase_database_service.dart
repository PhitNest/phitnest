import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phitnest/services/services.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../database_service.dart';

/// Firebase implementation of the database service.
class FirebaseDatabaseService extends DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<String?> updateFullUserModel(UserModel user) async {
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
  Future<UserModel?> getFullUserModel(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userPublicDocument =
        await firestore.collection(kUsersPublic).doc(uid).get();
    DocumentSnapshot<Map<String, dynamic>> userPrivateDocument =
        await firestore.collection(kUsersPrivate).doc(uid).get();
    return userPublicDocument.exists && userPrivateDocument.exists
        ? UserModel.fromInfo(
            publicInfo: UserPublicInfo.fromJson(userPublicDocument.data()!),
            privateInfo: UserPrivateInfo.fromJson(userPrivateDocument.data()!))
        : null;
  }

  @override
  Stream<UserPublicInfo?> getAllUsers() async* {
    for (DocumentSnapshot<Map<String, dynamic>> userDocument
        in (await firestore.collection(kUsersPublic).get()).docs) {
      yield userDocument.exists
          ? UserPublicInfo.fromJson(userDocument.data()!)
          : null;
    }
  }

  @override
  Stream<ChatMessage?> getChatMessageUpdates(
          String authorId, String recipientId) =>
      firestore
          .collection('$kMessages/$authorId/$recipientId')
          .snapshots()
          .asyncExpand((snapshot) async* {
        for (DocumentChange<Map<String, dynamic>> update
            in snapshot.docChanges) {
          yield update.doc.exists
              ? ChatMessage.fromJson(update.doc.data()!)
              : null;
        }
        yield null;
      });

  @override
  Stream<ChatMessage?> getRecentChatMessagesFromAuthor(
      String authorId, String recipientId,
      {int quantity = 1}) async* {
    for (DocumentSnapshot<Map<String, dynamic>> chatDocument in (await firestore
            .collection('$kMessages/$authorId/$recipientId')
            .orderBy('timeStamp', descending: true)
            .limit(quantity)
            .get())
        .docs) {
      yield chatDocument.exists
          ? ChatMessage.fromJson(chatDocument.data()!)
          : null;
    }
    yield null;
  }

  @override
  Stream<ChatMessage?> getRecentChatMessages(String userId, String otherUserId,
      {int quantity = 1}) async* {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docSnapshots =
        (await firestore
                .collection('$kMessages/$userId/$otherUserId')
                .orderBy('timeStamp', descending: true)
                .limit(quantity)
                .get())
            .docs
          ..addAll((await firestore
                  .collection('$kMessages/$otherUserId/$userId')
                  .orderBy('timeStamp', descending: true)
                  .limit(quantity)
                  .get())
              .docs);
    for (DocumentSnapshot<Map<String, dynamic>> chatDocument in docSnapshots) {
      yield chatDocument.exists
          ? ChatMessage.fromJson(chatDocument.data()!)
          : null;
    }
    yield null;
  }
}
