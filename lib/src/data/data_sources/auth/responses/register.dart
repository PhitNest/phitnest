import '../../../../domain/entities/entities.dart';

class RegisterResponse extends Entity<RegisterResponse> {
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
        user: Entities.fromJson(json['user']),
        uploadUrl: json['uploadUrl'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'uploadUrl': uploadUrl,
      };

  @override
  List<Object?> get props => [user, uploadUrl];
}
