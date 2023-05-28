part of '../auth.dart';

const kMaxUserId = 100000000;
const kSandboxEmailToUserMapJsonKey = 'email_to_user_map';
const kSandboxIdToUserMapJsonKey = 'id_to_user_map';
const kSandboxDataCacheKey = 'sandbox_data';
const kCurrentUserJsonKey = 'current_user';

bool validSandboxConfirmationCode(String code) =>
    code.endsWith('1') ||
    code.endsWith('3') ||
    code.endsWith('5') ||
    code.endsWith('7') ||
    code.endsWith('9');

class Sandbox extends Auth {
  final Map<String, SandboxUserData> emailToUserMap;
  final Map<String, SandboxUserData> idToUserMap;
  SandboxUserData? currentUser;

  static Sandbox? getFromCache() => cacheLoaded
      ? getSecureCachedObject(
          kSandboxDataCacheKey,
          (json) => Sandbox.fromJson(json),
        )
      : null;

  static Future<void> clearSandboxCache() =>
      cacheSecureObject(kSandboxDataCacheKey, null);

  Sandbox({
    required this.emailToUserMap,
    required this.idToUserMap,
    required this.currentUser,
  });

  @override
  Future<LoginResponse> login(
    String email,
    String password,
  ) async {
    final user = emailToUserMap[email];
    if (user == null) {
      return const LoginFailure(LoginFailureType.noSuchUser);
    } else if (!user.confirmed) {
      return const LoginFailure(LoginFailureType.confirmationRequired);
    } else if (user.password != password) {
      return const LoginFailure(LoginFailureType.invalidEmailPassword);
    } else {
      currentUser = user;
      await cacheSecureObject(
        kSandboxDataCacheKey,
        this,
      );
      return LoginSuccess(user.userId);
    }
  }

  @override
  Future<ChangePasswordFailure?> changePassword({
    required String email,
    required String newPassword,
  }) async {
    final user = emailToUserMap[email];
    if (user == null) {
      return const ChangePasswordTypedFailure(
        ChangePasswordFailureType.noSuchUser,
      );
    } else if (validatePassword(newPassword) != null) {
      return const ChangePasswordTypedFailure(
        ChangePasswordFailureType.invalidPassword,
      );
    } else {
      emailToUserMap[email] = SandboxUserData(
        email: email,
        userId: user.userId,
        password: newPassword,
        confirmed: user.confirmed,
        userAttributes: user.userAttributes,
      );
      return null;
    }
  }

  @override
  Future<RegisterResponse> register(
    String email,
    String password,
    List<AttributeArg> userAttributes,
  ) async {
    final user = emailToUserMap[email];
    if (user == null) {
      final emailValidation = EmailValidator.validateEmail(email);
      if (emailValidation == null) {
        final passwordProblems = validatePassword(password);
        if (passwordProblems != null) {
          return ValidationFailure(
            ValidationFailureType.invalidPassword,
            passwordProblems,
          );
        } else {
          String userId = Random().nextInt(kMaxUserId).toString();
          while (idToUserMap.containsKey(userId)) {
            userId = Random().nextInt(kMaxUserId).toString();
          }
          final newUser = SandboxUserData(
            userId: userId,
            email: email,
            password: password,
            confirmed: false,
            userAttributes: userAttributes,
          );
          emailToUserMap[email] = newUser;
          idToUserMap[userId] = newUser;
          // Don't save the unconfirmed user in the cache
          await cacheSecureObject(
            kSandboxDataCacheKey,
            this,
          );
          return RegisterSuccess(userId);
        }
      } else {
        return ValidationFailure(
          ValidationFailureType.invalidEmail,
          emailValidation,
        );
      }
    } else {
      return const RegisterFailure(
        RegisterFailureType.userExists,
      );
    }
  }

  @override
  Map<String, Serializable> toJson() => {
        kSandboxEmailToUserMapJsonKey: SerializableMap(emailToUserMap),
        kSandboxIdToUserMapJsonKey: SerializableMap(idToUserMap),
        ...(currentUser != null ? {kCurrentUserJsonKey: currentUser!} : {}),
      };

  factory Sandbox.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          kSandboxEmailToUserMapJsonKey: final Map<String, Map<String, dynamic>>
              emailToUserMap,
          kSandboxIdToUserMapJsonKey: final Map<String, Map<String, dynamic>>
              idToUserMap,
          kCurrentUserJsonKey: final Map<String, dynamic> currentUserMap
        } =>
          Sandbox(
            emailToUserMap: emailToUserMap.map(
              (email, userJson) => MapEntry(
                email,
                SandboxUserData.fromJson(userJson),
              ),
            ),
            idToUserMap: idToUserMap.map(
              (id, userJson) => MapEntry(
                id,
                SandboxUserData.fromJson(userJson),
              ),
            ),
            currentUser: SandboxUserData.fromJson(currentUserMap),
          ),
        _ => throw FormatException('Invalid JSON for Sandbox: $json'),
      };

  @override
  Future<bool> confirmEmail(
    String email,
    String code,
  ) async {
    if (!emailToUserMap.containsKey(email)) {
      return false;
    } else if (emailToUserMap[email]!.confirmed) {
      return true;
    } else if (!validSandboxConfirmationCode(code)) {
      return false;
    } else {
      final user = emailToUserMap[email]!;
      final updatedUser = SandboxUserData(
        userId: user.userId,
        email: user.email,
        password: user.password,
        confirmed: true,
        userAttributes: user.userAttributes,
      );
      emailToUserMap[email] = updatedUser;
      idToUserMap[user.userId] = updatedUser;
      await cacheSecureObject(
        kSandboxDataCacheKey,
        this,
      );
      return true;
    }
  }

  @override
  Future<bool> resendConfirmationEmail(String email) async =>
      emailToUserMap.containsKey(email);

  @override
  Future<SubmitForgotPasswordFailure?> submitForgotPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    if (!emailToUserMap.containsKey(email)) {
      return SubmitForgotPasswordFailure.noSuchUser;
    } else if (!validSandboxConfirmationCode(code)) {
      return SubmitForgotPasswordFailure.invalidCode;
    } else {
      final user = emailToUserMap[email]!;
      final updatedUser = SandboxUserData(
        userId: user.userId,
        email: user.email,
        password: newPassword,
        confirmed: user.confirmed,
        userAttributes: user.userAttributes,
      );
      emailToUserMap[email] = updatedUser;
      idToUserMap[user.userId] = updatedUser;
      await cacheSecureObject(
        kSandboxDataCacheKey,
        this,
      );
      return null;
    }
  }

  @override
  Future<ForgotPasswordFailure?> forgotPassword(String email) async {
    if (!emailToUserMap.containsKey(email)) {
      return ForgotPasswordFailure.noSuchUser;
    } else {
      return null;
    }
  }

  @override
  Future<RefreshSessionFailure?> refreshSession() async {
    if (currentUser == null) {
      return RefreshSessionFailure.noSuchUser;
    } else {
      return null;
    }
  }
}
