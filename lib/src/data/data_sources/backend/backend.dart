export 'auth.backend.dart';
export 'gym.backend.dart';
export 'profile_picture.backend.dart';

enum Routes {
  login,
  register,
  forgotPassword,
  user,
  confirmRegister,
  getUploadUrlUnauthorized,
  nearestGyms,
  resendConfirmationCode,
}

extension Paths on Routes {
  String get path {
    switch (this) {
      case Routes.resendConfirmationCode:
        return '/auth/resendConfirmation';
      case Routes.login:
        return '/auth/login';
      case Routes.register:
        return '/auth/register';
      case Routes.forgotPassword:
        return '/auth/forgotPassword';
      case Routes.user:
        return '/user';
      case Routes.confirmRegister:
        return '/auth/confirmRegister';
      case Routes.getUploadUrlUnauthorized:
        return '/profilePicture/unauthorized';
      case Routes.nearestGyms:
        return '/gym/nearest';
    }
  }
}
