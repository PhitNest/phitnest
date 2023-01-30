import 'package:equatable/equatable.dart';

import '../../../../../common/utils/utils.dart';
import '../../../../../domain/entities/entities.dart';

class RegisterResponseParser extends Parser<RegisterResponse> {
  const RegisterResponseParser() : super();

  @override
  RegisterResponse fromJson(Map<String, dynamic> json) => RegisterResponse(
        user: UserParser().fromJson(json['user']),
        uploadUrl: json['uploadUrl'],
      );
}

class RegisterResponse extends Equatable {
  final String uploadUrl;
  final UserEntity user;

  const RegisterResponse({
    required this.user,
    required this.uploadUrl,
  }) : super();

  @override
  List<Object?> get props => [user, uploadUrl];
}
