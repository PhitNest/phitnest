export 'social_api.dart';
export 'authentication_api.dart';
export 'storage_api.dart';

import 'firebase/firebase_api.dart';
import 'authentication_api.dart';
import 'social_api.dart';
import 'storage_api.dart';

abstract class ApiState {}

abstract class Api<T extends ApiState> {
  T get initState;

  late final T state;

  Api() {
    state = initState;
  }
}

Map<Type, Api> _apiMap = {
  SocialApi: FirebaseSocialApi(),
  StorageApi: FirebaseStorageApi(),
  AuthenticationApi: FirebaseAuthenticationApi(),
};

/// Get the api singleton instance
T api<T extends Api>() => _apiMap[T]! as T;