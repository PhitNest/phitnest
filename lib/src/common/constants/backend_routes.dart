enum HttpMethod {
  get,
  post,
  put,
  delete,
}

class Route {
  final String path;
  final HttpMethod method;

  const Route(this.path, this.method);
}

enum Routes {
  login,
  register,
  forgotPassword,
  getUser,
  confirmRegister,
  getUploadUrlUnauthorized,
  nearestGyms,
  resendConfirmationCode,
}

extension RouteInstance on Routes {
  Route get instance {
    switch (this) {
      case Routes.login:
        return const Route('/auth/login', HttpMethod.post);
      case Routes.register:
        return const Route('/auth/register', HttpMethod.post);
      case Routes.forgotPassword:
        return const Route('/auth/forgotPassword', HttpMethod.post);
      case Routes.getUser:
        return const Route('/user', HttpMethod.get);
      case Routes.confirmRegister:
        return const Route('/auth/confirmRegister', HttpMethod.post);
      case Routes.getUploadUrlUnauthorized:
        return const Route('/profilePicture/unauthorized', HttpMethod.get);
      case Routes.nearestGyms:
        return const Route('/gym/nearest', HttpMethod.get);
      case Routes.resendConfirmationCode:
        return const Route('/auth/resendConfirmation', HttpMethod.post);
    }
  }
}

extension Paths on Routes {
  String get path => instance.path;
}

extension Method on Routes {
  HttpMethod get method => instance.method;
}
