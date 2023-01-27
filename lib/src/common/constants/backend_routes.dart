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
  forgotPasswordSubmit,
  getUser,
  confirmRegister,
  getUploadUrlUnauthorized,
  nearestGyms,
  resendConfirmationCode,
  signOut,
  refreshSession,
  explore,
  sendFriendRequest,
  denyFriendRequest,
  removeFriend,
  friendsAndRequests,
  friendsAndMessages,
  getDirectMessages,
  unauthorizedUploadPictureUpload,
  profilePictureUpload,
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
      case Routes.forgotPasswordSubmit:
        return const Route('/auth/forgotPasswordSubmit', HttpMethod.post);
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
      case Routes.signOut:
        return const Route('/auth/signOut', HttpMethod.post);
      case Routes.refreshSession:
        return const Route('/auth/refreshSession', HttpMethod.post);
      case Routes.explore:
        return const Route('/user/explore', HttpMethod.get);
      case Routes.sendFriendRequest:
        return const Route('/friendRequest', HttpMethod.post);
      case Routes.denyFriendRequest:
        return const Route('/friendRequest/deny', HttpMethod.post);
      case Routes.removeFriend:
        return const Route('/friendship', HttpMethod.delete);
      case Routes.friendsAndRequests:
        return const Route('/friendship/friendsAndRequests', HttpMethod.get);
      case Routes.friendsAndMessages:
        return const Route('/friendship/friendsAndMessages', HttpMethod.get);
      case Routes.getDirectMessages:
        return const Route('/directMessage/list', HttpMethod.get);
      case Routes.unauthorizedUploadPictureUpload:
        return const Route('/profilePicture/unauthorized', HttpMethod.get);
      case Routes.profilePictureUpload:
        return const Route('/profilePicture/upload', HttpMethod.get);
    }
  }
}

extension Paths on Routes {
  String get path => instance.path;
}

extension Method on Routes {
  HttpMethod get method => instance.method;
}
