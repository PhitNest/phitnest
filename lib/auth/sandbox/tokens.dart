import '../auth.dart';

const kExpiresAtJsonKey = 'expires_at';

class SandboxTokens extends Tokens {
  final DateTime expiresAt;

  const SandboxTokens({
    required this.expiresAt,
  }) : super();

  bool get isValid => DateTime.now().isBefore(expiresAt);

  @override
  Map<String, dynamic> toJson() => {
        kExpiresAtJsonKey: expiresAt.millisecondsSinceEpoch,
      };

  factory SandboxTokens.fromJson(Map<String, dynamic> json) => SandboxTokens(
        expiresAt: DateTime.fromMillisecondsSinceEpoch(json[kExpiresAtJsonKey]),
      );

  @override
  List<Object?> get props => [
        expiresAt,
      ];
}
