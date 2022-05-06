import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../database_service.dart';

/// Firebase implementation of the database service.
class FirestoreDatabaseService extends DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<String?> updateUserModel(UserModel user) async {
    try {
      await firestore.collection(USERS).doc(user.userID).set(user.toJson());
      return null;
    } catch (e) {
      return '$e';
    }
  }

  @override
  Future<UserModel?> getUserModel(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await firestore.collection(USERS).doc(uid).get();
    return userDocument.exists
        ? UserModel.fromJson(userDocument.data() ?? {})
        : null;
  }

  @override
  Future<bool> updateLocation(UserModel user) async {
    Position? position = await getCurrentLocation();

    if (position != null) {
      user.location = UserLocation(
          latitude: position.latitude, longitude: position.longitude);
      await updateUserModel(user);
      return true;
    }
    return false;
  }
}
