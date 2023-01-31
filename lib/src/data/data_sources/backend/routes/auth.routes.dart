import '../../../../domain/entities/entities.dart';
import '../backend.dart';

const kLoginRoute = Route<LoginRequest, LoginResponse>(
  '/auth/login',
  HttpMethod.post,
  LoginResponseParser(),
);

const kRegisterRoute = Route<RegisterRequest, RegisterResponse>(
  '/auth/register',
  HttpMethod.post,
  RegisterResponseParser(),
);

const kForgotPasswordRoute = Route<ForgotPasswordRequest, void>(
  '/auth/forgotPassword',
  HttpMethod.post,
  Void(),
);

const kForgotPasswordSubmitRoute = Route<ForgotPasswordSubmitRequest, void>(
  '/auth/forgotPasswordSubmit',
  HttpMethod.post,
  Void(),
);

const kResendConfirmationRoute = Route<ResendConfirmationRequest, void>(
  '/auth/resendConfirmation',
  HttpMethod.post,
  Void(),
);

const kConfirmRegisterRoute =
    Route<ConfirmRegisterRequest, ProfilePictureUserEntity>(
  '/auth/confirmRegister',
  HttpMethod.post,
  ProfilePictureUserParser(),
);

const kRefreshSessionRoute =
    Route<RefreshSessionRequest, RefreshSessionResponse>(
  '/auth/refreshSession',
  HttpMethod.post,
  RefreshSessionResponseParser(),
);

const kSignOutRoute = Route<SignOutRequest, void>(
  '/auth/signOut',
  HttpMethod.post,
  Void(),
);
