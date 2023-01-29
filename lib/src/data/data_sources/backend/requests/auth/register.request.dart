import '../requests.dart';

class RegisterRequest extends Request {
  static const kEmpty = RegisterRequest(
    email: '',
    password: '',
    firstName: '',
    lastName: '',
    gymId: '',
  );

  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String gymId;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.gymId,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'gymId': gymId,
      };

  @override
  List<Object?> get props =>
      [email, password, email, password, firstName, lastName, gymId];
}
