import 'package:dartz/dartz.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';

abstract class IHttpAdapter {
  Future<Either<Either<Map<String, dynamic>, List<dynamic>>, Failure>> request(
    Route route, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    String? authorization,
  });
}
