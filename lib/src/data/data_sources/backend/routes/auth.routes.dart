import '../../../../domain/entities/entities.dart';
import '../backend.dart';
import 'routes.dart';

const kLoginRoute =
    Route<LoginRequest, LoginResponse>('/auth/login', HttpMethod.post);

const kRegisterRoute =
    Route<RegisterRequest, RegisterResponse>('/auth/register', HttpMethod.post);

const kForgotPasswordRoute = Route<ForgotPasswordRequest, EmptyResponse>(
    '/auth/forgotPassword', HttpMethod.post);

const kForgotPasswordSubmitRoute =
    Route<ForgotPasswordSubmitRequest, EmptyResponse>(
        '/auth/forgotPasswordSubmit', HttpMethod.post);

const kResendConfirmationRoute =
    Route<ResendConfirmationRequest, EmptyResponse>(
        '/auth/resendConfirmation', HttpMethod.post);

const kConfirmRegisterRoute = Route<ConfirmRegisterRequest, UserEntity>(
    '/auth/confirmRegister', HttpMethod.post);

const kRefreshSessionRoute = Route<RefreshSessionRequest, EmptyResponse>(
    '/auth/refreshSession', HttpMethod.post);

const kSignOutRoute =
    Route<SignOutRequest, EmptyResponse>('/auth/signOut', HttpMethod.post);
