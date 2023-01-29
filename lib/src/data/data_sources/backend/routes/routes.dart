import '../../../../common/utils/utils.dart';

enum HttpMethod {
  get,
  post,
  put,
  delete,
}

class Route<ReqType extends ToJson, ResType extends FromJson<ResType>> {
  final String path;
  final HttpMethod method;

  const Route(this.path, this.method);
}
