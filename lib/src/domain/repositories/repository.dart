library repository;

import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/backend/backend.dart';
import '../../data/cache/cache.dart';
import '../entities/entities.dart';

part 'auth.dart';

abstract class Repositories {
  static const auth = _Auth();
}
