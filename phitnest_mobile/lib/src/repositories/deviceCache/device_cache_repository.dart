import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../repository.dart';

class DeviceCacheRepository extends Repository {
  final _storage = new FlutterSecureStorage();

  static const String kCompletedOnBoarding = 'completedOnBoarding';

  Future<bool> get completedOnBoarding =>
      _storage.read(key: kCompletedOnBoarding).then((res) => res != null);

  Future<void> completeOnBoarding() =>
      _storage.write(key: kCompletedOnBoarding, value: 'true');
}
