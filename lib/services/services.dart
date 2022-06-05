export 'database_service.dart';
export 'authentication_service.dart';
export 'storage_service.dart';
export 'chat_service.dart';

import '../locator.dart';
import 'authentication_service.dart';
import 'database_service.dart';
import 'storage_service.dart';
import 'chat_service.dart';

/// Instance of database service
DatabaseService get databaseService => locator<DatabaseService>();

/// Instance of storage service
StorageService get storageService => locator<StorageService>();

/// Instance of authentication service
AuthenticationService get authService => locator<AuthenticationService>();

/// Instance of chat service
ChatService get chatService => locator<ChatService>();
