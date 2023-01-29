import '../../../../../domain/entities/entities.dart';
import '../responses.dart';

class RegisterResponse extends Response<RegisterResponse> {
  static const kEmpty = RegisterResponse(
    user: UserEntity.kEmpty,
    uploadUrl: '',
  );

  final String uploadUrl;
  final UserEntity user;

  const RegisterResponse({
    required this.user,
    required this.uploadUrl,
  }) : super();

  @override
  RegisterResponse fromJson(Map<String, dynamic> json) => RegisterResponse(
        user: Entity.jsonFactory(json['user']),
        uploadUrl: json['uploadUrl'],
      );

  @override
  List<Object?> get props => [user, uploadUrl];
}
