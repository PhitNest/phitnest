import '../models/user_model.dart';

abstract class DatabaseService {
  /// Update the given user model in the database
  Future<String?> updateUserModel(UserModel user);

  /// Get the user model for the given uid
  Future<UserModel?> getUserModel(String uid);
}
