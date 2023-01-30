import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../data_sources/backend/routes/routes.dart';

abstract class IHttpAdapter {
  FEither<ResType, Failure> request<ResType, ReqType extends Writeable>(
    Route<ReqType, ResType> route,
    ReqType data, {
    Map<String, dynamic>? headers,
    String? authorization,
  });

  FEither<List<ResType>, Failure>
      requestList<ResType, ReqType extends Writeable>(
    Route<ReqType, ResType> route,
    ReqType data, {
    Map<String, dynamic>? headers,
    String? authorization,
  });
}
