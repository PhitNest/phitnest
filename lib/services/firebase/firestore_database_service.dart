import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/constants.dart';
import '../../models/user_model.dart';

import '../database_service.dart';

class FirestoreDatabaseService extends DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<String?> updateUserModel(UserModel user) async {
    return await firestore
        .collection(USERS)
        .doc(user.userID)
        .set(user.toJson())
        .then((document) {
      return null;
    }, onError: (e) {
      return e;
    });
  }

  @override
  Future<UserModel?> getUserModel(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await firestore.collection(USERS).doc(uid).get();
    if (userDocument.exists) {
      return UserModel.fromJson(userDocument.data() ?? {});
    } else {
      return null;
    }
  }
}
