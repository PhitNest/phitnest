import '../../models/models.dart';

/// Abstract representation of the database service
abstract class DatabaseService {
  /// Update the given public and private user model in the
  /// database. Returns null on success, or error message.
  Future<String?> updateFullUserModel(UserModel user);

  /// Get the public and private user models for the given uid
  Future<UserModel?> getFullUserModel(String uid);

  /// Opens a stream with all public user data from the backend
  Stream<UserPublicInfo?> getAllUsers();
}
