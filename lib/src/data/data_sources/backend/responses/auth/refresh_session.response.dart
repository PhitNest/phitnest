import 'package:equatable/equatable.dart';

import '../../../../../common/utils/utils.dart';

class RefreshSessionResponseParser extends Parser<RefreshSessionResponse> {
  const RefreshSessionResponseParser() : super();

  @override
  RefreshSessionResponse fromJson(Map<String, dynamic> json) =>
      RefreshSessionResponse(
        accessToken: json['accessToken'],
        idToken: json['idToken'],
      );
}

class RefreshSessionResponse extends Equatable {
  final String accessToken;
  final String idToken;

  const RefreshSessionResponse({
    required this.accessToken,
    required this.idToken,
  }) : super();

  @override
  List<Object?> get props => [accessToken, idToken];
}
