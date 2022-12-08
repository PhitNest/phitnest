import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IGetAuthTokenUseCase {
  Future<Either<String, Failure>> getAccessToken();
}
