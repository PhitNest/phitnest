import 'package:equatable/equatable.dart';

const kSandboxEmailJsonKey = "email";
const kSandboxPasswordJsonKey = "password";
const kSandboxConfirmedJsonKey = "confirmed";
const kSandboxUserIdJsonKey = "userId";

class SandboxUserData extends Equatable {
  final String email;
  final String userId;
  final String password;
  final bool confirmed;

  const SandboxUserData({
    required this.email,
    required this.userId,
    required this.password,
    required this.confirmed,
  });

  @override
  List<Object?> get props => [
        email,
        userId,
        password,
        confirmed,
      ];

  factory SandboxUserData.fromJson(Map<String, dynamic> json) =>
      SandboxUserData(
        email: json[kSandboxEmailJsonKey],
        password: json[kSandboxPasswordJsonKey],
        confirmed: json[kSandboxConfirmedJsonKey],
        userId: json[kSandboxUserIdJsonKey],
      );

  Map<String, dynamic> toJson() => {
        kSandboxEmailJsonKey: email,
        kSandboxPasswordJsonKey: password,
        kSandboxConfirmedJsonKey: confirmed,
        kSandboxUserIdJsonKey: userId,
      };
}
