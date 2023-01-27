import 'package:equatable/equatable.dart';

class RefreshTokenResponse extends Equatable {
  final String accessToken;
  final String idToken;

  RefreshTokenResponse({
    required this.accessToken,
    required this.idToken,
  }) : super();

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        accessToken: json['accessToken'],
        idToken: json['idToken'],
      );

  @override
  List<Object?> get props => [accessToken, idToken];
}
