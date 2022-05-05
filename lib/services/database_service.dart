import '../models/user_model.dart';

/// Abstract representation of the database service
abstract class DatabaseService {
  /// Update the given user model in the database
  Future<String?> updateUserModel(UserModel user);

  /// Get the user model for the given uid
  Future<UserModel?> getUserModel(String uid);

  /// Updates the users location using the location service, and updates the
  /// user document.
  Future<bool> updateLocation(UserModel user);
}
