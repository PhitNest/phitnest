import '../../models/models.dart';

/// Abstract representation of the database service
abstract class DatabaseService {
  /// Update the given user model in the database. Returns null on success, or
  /// error message.
  Future<String?> updateUserModel(UserModel user);

  /// Get the user model for the given uid
  Future<UserModel?> getUserModel(String uid);

  /// Updates the users location using the location service, and updates the
  /// user document. Returns true if the location was updated.
  Future<bool> updateLocation(UserModel user);
}
