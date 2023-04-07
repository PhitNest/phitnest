import 'dart:math';

import 'package:sealed_unions/sealed_unions.dart';

import '../../cache.dart' as cache;
import '../../serializable.dart';
import '../../validators/validators.dart';
import '../auth.dart';
import '../failures.dart';
import 'user_data.dart';

const kSandboxTokenDuration = Duration(seconds: 45);
const kMaxUserId = 100000000;
const kSandboxEmailToUserMapJsonKey = "email_to_user_map";
const kSandboxIdToUserMapJsonKey = "id_to_user_map";
const kSandboxDataCacheKey = "sandbox_data";
const kCurrentUserJsonKey = "current_user";

bool validSandboxConfirmationCode(String code) =>
    code.endsWith("1") ||
    code.endsWith("3") ||
    code.endsWith("5") ||
    code.endsWith("7") ||
    code.endsWith("9");

class Sandbox extends Auth with Serializable {
  final Map<String, SandboxUserData> emailToUserMap;
  final Map<String, SandboxUserData> idToUserMap;
  SandboxUserData? currentUser;

  static Sandbox? getFromCache() => cache.loaded
      ? cache.getSecureCachedObject(
          kSandboxDataCacheKey,
          (json) => Sandbox.fromJson(json),
        )
      : null;

  static Future<void> clearSandboxCache() =>
      cache.cacheSecureObject(kSandboxDataCacheKey, null);

  Sandbox({
    required this.emailToUserMap,
    required this.idToUserMap,
    required this.currentUser,
  });

  @override
  Future<Union2<String, LoginFailure>> login(
    String email,
    String password,
  ) async {
    final user = emailToUserMap[email];
    if (user == null) {
      return Union2Second(LoginFailure(LoginFailureType.noSuchUser));
    } else if (!user.confirmed) {
      return Union2Second(LoginFailure(LoginFailureType.confirmationRequired));
    } else if (user.password != password) {
      return Union2Second(LoginFailure(LoginFailureType.invalidEmailPassword));
    } else {
      currentUser = user;
      await cache.cacheSecureObject(
        kSandboxDataCacheKey,
        this,
      );
      return Union2First(user.userId);
    }
  }

  @override
  Future<Union2<String, RegistrationFailure>> register(
    String email,
    String password,
  ) async {
    final user = emailToUserMap[email];
    if (user == null) {
      if (EmailValidator.validateEmail(email)) {
        final passwordProblems = validatePassword(password);
        if (passwordProblems != null) {
          return Union2Second(
            RegistrationFailure(
              Union2Second(
                ValidationFailure(
                  ValidationFailureType.invalidPassword,
                  passwordProblems,
                ),
              ),
            ),
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
          );
          emailToUserMap[email] = newUser;
          idToUserMap[userId] = newUser;
          // Don't save the unconfirmed user in the cache
          await cache.cacheSecureObject(
            kSandboxDataCacheKey,
            this,
          );
          return Union2First(userId);
        }
      } else {
        return Union2Second(
          RegistrationFailure(
            Union2Second(
              const ValidationFailure(
                ValidationFailureType.invalidEmail,
                "Invalid email.",
              ),
            ),
          ),
        );
      }
    } else {
      return Union2Second(
        RegistrationFailure(
          Union2First(
            RegistrationFailureType.userExists,
          ),
        ),
      );
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        "mode": "sandbox",
        kSandboxEmailToUserMapJsonKey: emailToUserMap.map(
          (key, value) => MapEntry(key, value.toJson()),
        ),
        kSandboxIdToUserMapJsonKey: idToUserMap.map(
          (key, value) => MapEntry(key, value.toJson()),
        ),
        ...(currentUser != null
            ? {
                kCurrentUserJsonKey: currentUser!.toJson(),
              }
            : {}),
      };

  factory Sandbox.fromJson(Map<String, dynamic> json) => Sandbox(
        emailToUserMap: Map.fromEntries(
          json[kSandboxEmailToUserMapJsonKey].entries.map(
                (entry) => MapEntry(
                  entry.key,
                  SandboxUserData.fromJson(entry.value),
                ),
              ),
        ),
        idToUserMap: Map.fromEntries(
          json[kSandboxIdToUserMapJsonKey].entries.map(
                (entry) => MapEntry(
                  entry.key,
                  SandboxUserData.fromJson(entry.value),
                ),
              ),
        ),
        currentUser: json[kCurrentUserJsonKey] == null
            ? null
            : SandboxUserData.fromJson(json[kCurrentUserJsonKey]),
      );

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
      );
      emailToUserMap[email] = updatedUser;
      idToUserMap[user.userId] = updatedUser;
      await cache.cacheSecureObject(
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
  Future<Union2<void, SubmitForgotPasswordFailure>> submitForgotPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    if (!emailToUserMap.containsKey(email)) {
      return Union2Second(SubmitForgotPasswordFailure(
          SubmitForgotPasswordFailureType.noSuchUser));
    } else if (!validSandboxConfirmationCode(code)) {
      return Union2Second(SubmitForgotPasswordFailure(
          SubmitForgotPasswordFailureType.invalidCode));
    } else {
      final user = emailToUserMap[email]!;
      final updatedUser = SandboxUserData(
        userId: user.userId,
        email: user.email,
        password: newPassword,
        confirmed: user.confirmed,
      );
      emailToUserMap[email] = updatedUser;
      idToUserMap[user.userId] = updatedUser;
      await cache.cacheSecureObject(
        kSandboxDataCacheKey,
        this,
      );
      return Union2First(null);
    }
  }

  @override
  Future<Union2<void, ForgotPasswordFailure>> forgotPassword(
      String email) async {
    if (!emailToUserMap.containsKey(email)) {
      return Union2Second(
          ForgotPasswordFailure(ForgotPasswordFailureType.noSuchUser));
    } else {
      return Union2First(null);
    }
  }

  @override
  Future<Union2<void, RefreshSessionFailure>> refreshSession() async {
    if (currentUser == null) {
      return Union2Second(
          RefreshSessionFailure(RefreshSessionFailureType.noSuchUser));
    } else {
      return Union2First(null);
    }
  }
}
