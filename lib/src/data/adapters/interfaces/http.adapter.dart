import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';

abstract class IHttpAdapter {
  FEither3<Map<String, dynamic>, List<dynamic>, Failure> request(
    Route route, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    String? authorization,
  });
}
