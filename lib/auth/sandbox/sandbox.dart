import 'dart:math';

import 'package:phitnest_core/auth/failures.dart';
import 'package:sealed_unions/sealed_unions.dart';

import '../../cache.dart' as cache;
import '../../failure.dart';
import '../../validators/validators.dart';
import '../auth.dart';
import 'tokens.dart';
import 'user_data.dart';

const kSandboxTokenDuration = Duration(seconds: 45);
const kMaxUserId = 100000000;
const kSandboxEmailToUserMapJsonKey = "email_to_user_map";
const kSandboxIdToUserMapJsonKey = "id_to_user_map";
const kSandboxDataCacheKey = "sandbox_data";

bool validSandboxConfirmationCode(String code) =>
    code.endsWith("1") ||
    code.endsWith("3") ||
    code.endsWith("5") ||
    code.endsWith("7") ||
    code.endsWith("9");

class Sandbox extends Auth {
  final Map<String, SandboxUserData> emailToUserMap;
  final Map<String, SandboxUserData> idToUserMap;

  static Sandbox? getFromCache() => cache.loaded
      ? cache.getSecureCachedObject(
          kSandboxDataCacheKey,
          (json) => Sandbox.fromJson(json),
        )
      : null;

  static Future<void> clearSandboxCache() =>
      cache.cacheSecureObject(kSandboxDataCacheKey, null);

  const Sandbox({
    required this.emailToUserMap,
    required this.idToUserMap,
  });

  @override
  List<Object?> get props => [
        emailToUserMap,
        idToUserMap,
      ];

  @override
  Future<Union4<Tokens, ConfirmationRequired, InvalidEmailPassword, Failure>>
      login(
    String email,
    String password,
  ) async {
    final user = emailToUserMap[email];
    if (user == null) {
      return Union4Fourth(const Failure(kNoSuchUserMessage));
    } else if (!user.confirmed) {
      return Union4Second(const ConfirmationRequired());
    } else if (user.password != password) {
      return Union4Third(const InvalidEmailPassword());
    } else {
      return Union4First(
        SandboxTokens(
          expiresAt: DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch +
                kSandboxTokenDuration.inMilliseconds,
          ),
        ),
      );
    }
  }

  @override
  Future<Union5<String, UserExists, InvalidEmail, InvalidPassword, Failure>>
      register(
    String email,
    String password,
  ) async {
    final user = emailToUserMap[email];
    if (user == null) {
      if (EmailValidator.validateEmail(email)) {
        final passwordProblems = validatePassword(password);
        if (passwordProblems != null) {
          return Union5Fourth(InvalidPassword(passwordProblems));
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
          await cache.cacheSecureObject(
            kSandboxDataCacheKey,
            Sandbox(
              emailToUserMap: emailToUserMap,
              idToUserMap: idToUserMap,
            ),
          );
          return Union5First(userId);
        }
      } else {
        return Union5Third(const InvalidEmail("Invalid email."));
      }
    } else {
      return Union5Second(const UserExists());
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
      );

  Future<Union2<void, Failure>> confirmEmail(
    String email,
    String code,
  ) async {
    final user = emailToUserMap[email];
    if (user == null) {
      return Union2Second(const Failure(kNoSuchUserMessage));
    } else if (user.confirmed) {
      return Union2First(null);
    } else if (!validSandboxConfirmationCode(code)) {
      return Union2Second(const Failure(kIncorrectCodeMessage));
    } else {
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
        Sandbox(
          emailToUserMap: emailToUserMap,
          idToUserMap: idToUserMap,
        ),
      );
      return Union2First(null);
    }
  }
}
