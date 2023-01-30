import '../requests.dart';

class RefreshSessionRequest extends Request {
  final String email;
  final String refreshToken;

  const RefreshSessionRequest({
    required this.email,
    required this.refreshToken,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'refreshToken': refreshToken,
      };

  @override
  List<Object?> get props => [email, refreshToken];
}
