import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../../domain/entities/entity.dart';

abstract class IHttpAdapter {
  FEither<ResType, Failure> requestJson<ResType extends Entity<ResType>,
      ReqType extends Entity<ReqType>>(
    Route route, {
    ReqType? data,
    Map<String, dynamic>? headers,
    String? authorization,
  });

  FEither<List<ResType>, Failure> requestList<ResType extends Entity<ResType>,
      ReqType extends Entity<ReqType>>(
    Route route, {
    ReqType? data,
    Map<String, dynamic>? headers,
    String? authorization,
  });

  Future<Failure?> requestVoid<ReqType extends Entity<ReqType>>(
    Route route, {
    ReqType? data,
    Map<String, dynamic>? headers,
    String? authorization,
  });
}
