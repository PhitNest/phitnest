import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

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
}
