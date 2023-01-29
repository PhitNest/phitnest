import '../../../../domain/entities/entity.dart';

class RefreshSessionRequest extends Entity<RefreshSessionRequest> {
  static const kEmpty = RefreshSessionRequest(email: '', refreshToken: '');

  final String email;
  final String refreshToken;

  const RefreshSessionRequest({
    required this.email,
    required this.refreshToken,
  }) : super();

  @override
  RefreshSessionRequest fromJson(Map<String, dynamic> json) =>
      RefreshSessionRequest(
        email: json['email'],
        refreshToken: json['refreshToken'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'refreshToken': refreshToken,
      };

  @override
  List<Object?> get props => [email, refreshToken];
}
