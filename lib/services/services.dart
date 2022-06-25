export 'database_service.dart';
export 'authentication_service.dart';
export 'storage_service.dart';
export 'chat_service.dart';

import 'firebase/firebase_service.dart';
import 'authentication_service.dart';
import 'database_service.dart';
import 'storage_service.dart';
import 'chat_service.dart';

/// Singleton instances
DatabaseService databaseService = FirebaseDatabaseService();
StorageService storageService = FirebaseStorageService();
AuthenticationService authService = FirebaseAuthenticationService();
ChatService chatService = FirebaseChatService();
