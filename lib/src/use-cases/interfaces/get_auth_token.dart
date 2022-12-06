import 'package:dartz/dartz.dart';

import '../../failures/failures.dart';

abstract class IGetAuthTokenUseCase {
  Future<Either<String, Failure>> getAccessToken();
}
