import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';
import '../../../domain/entities/entities.dart';
import '../../adapters/adapters.dart';
import 'requests/requests.dart';
import 'responses/responses.dart';

export 'cache.dart';
export 'responses/responses.dart';

abstract class AuthDataSource {
  static FEither<LoginResponse, Failure> login(
    String email,
    String password,
  ) =>
      httpAdapter.requestJson(
        Routes.login.instance,
        data: LoginRequest(
          email: email,
          password: password,
        ),
      );

  static FEither<RegisterResponse, Failure> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String gymId,
  ) =>
      httpAdapter.requestJson(
        Routes.register.instance,
        data: RegisterRequest(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          gymId: gymId,
        ),
      );

  static Future<Failure?> forgotPassword(
    String email,
  ) =>
      httpAdapter.requestVoid(
        Routes.forgotPassword.instance,
        data: ForgotPasswordRequest(email: email),
      );

  static Future<Failure?> resendConfirmationCode(String email) =>
      httpAdapter.requestVoid(
        Routes.resendConfirmationCode.instance,
        data: ResendConfirmationRequest(email: email),
      );

  static FEither<UserEntity, Failure> confirmRegister(
    String email,
    String code,
  ) =>
      httpAdapter.requestJson(
        Routes.confirmRegister.instance,
        data: ConfirmRegisterRequest(
          email: email,
          code: code,
        ),
      );

  static Future<Failure?> forgotPasswordSubmit(
    String email,
    String password,
    String code,
  ) =>
      httpAdapter.requestVoid(
        Routes.forgotPasswordSubmit.instance,
        data: ForgotPasswordSubmitRequest(
          email: email,
          code: code,
          password: password,
        ),
      );

  static FEither<RefreshTokenResponse, Failure> refreshSession(
    String email,
    String refreshToken,
  ) =>
      httpAdapter.requestJson(
        Routes.refreshSession.instance,
        data: RefreshSessionRequest(
          email: email,
          refreshToken: refreshToken,
        ),
      );

  static Future<Failure?> signOut(bool allDevices) => httpAdapter.requestVoid(
        Routes.signOut.instance,
        data: SignOutRequest(allDevices: allDevices),
      );
}
