import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../database_service.dart';

/// Firebase implementation of the database service.
class FirebaseDatabaseService extends DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<String?> updateUserModel(UserModel user) async {
    try {
      await firestore.collection(kUsers).doc(user.userId).set(user.toJson());
      return null;
    } catch (e) {
      return '$e';
    }
  }

  @override
  Future<UserModel?> getUserModel(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await firestore.collection(kUsers).doc(uid).get();
    return userDocument.exists
        ? UserModel.fromJson(userDocument.data() ?? {})
        : null;
  }

  @override
  Stream<UserModel?> getAllUsers() async* {
    for (DocumentSnapshot<Map<String, dynamic>> userDocument
        in (await firestore.collection(kUsers).get()).docs) {
      yield userDocument.exists
          ? UserModel.fromJson(userDocument.data() ?? {})
          : null;
    }
  }
}
