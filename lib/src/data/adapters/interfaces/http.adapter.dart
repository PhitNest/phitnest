import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';

enum HttpMethod {
  get,
  post,
  put,
  delete,
}

abstract class IHttpAdapter {
  Future<Either<Either<Map<String, dynamic>, List<dynamic>>, Failure>> request(
    HttpMethod method,
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    String? authorization,
  });
}
