import '../responses.dart';

class RefreshTokenResponse extends Response<RefreshTokenResponse> {
  static const kEmpty = RefreshTokenResponse(accessToken: "", idToken: "");

  final String accessToken;
  final String idToken;

  const RefreshTokenResponse({
    required this.accessToken,
    required this.idToken,
  }) : super();

  @override
  RefreshTokenResponse fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        accessToken: json['accessToken'],
        idToken: json['idToken'],
      );

  @override
  List<Object?> get props => [accessToken, idToken];
}
