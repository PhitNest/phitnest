import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../../constants/constants.dart';
import '../../models/user_location_model.dart';
import '../../models/user_model.dart';

import '../database_service.dart';

/// Firebase implementation of the database service.
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
