import '../../../../common/utils/utils.dart';

export 'auth.routes.dart';
export 'friendship.routes.dart';
export 'friend_request.routes.dart';
export 'direct_message.routes.dart';
export 'profile_picture.routes.dart';
export 'gym.routes.dart';

enum HttpMethod {
  get,
  post,
  put,
  delete,
}

class Route<ReqType extends Writeable, ResType> {
  final String path;
  final HttpMethod method;
  final Parser<ResType> parser;

  const Route(this.path, this.method, this.parser) : super();
}
