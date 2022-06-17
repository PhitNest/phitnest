import '../../models/models.dart';

/// Abstract representation of the database service
abstract class DatabaseService {
  /// Update the given user model in the database. Returns null on success, or
  /// error message.
  Future<String?> updateUserModel(UserModel user);

  /// Get the user model for the given uid
  Future<UserModel?> getUserModel(String uid);

  /// Opens a stream with all users from the backend
  Stream<UserModel?> getAllUsers();
}
