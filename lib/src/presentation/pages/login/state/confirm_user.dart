import 'login_state.dart';

class ConfirmUserState extends LoginState {
  final String email;
  final String password;

  const ConfirmUserState({
    required this.email,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [email, password];
}
