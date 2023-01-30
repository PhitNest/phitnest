import '../requests.dart';

class GetUploadUrlUnauthorizedRequest extends Request {
  final String email;
  final String password;

  const GetUploadUrlUnauthorizedRequest({
    required this.email,
    required this.password,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };

  @override
  List<Object?> get props => [email, password];
}
