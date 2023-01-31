import '../../../../data/data_sources/backend/backend.dart';
import 'login_state.dart';

class LoginSuccessState extends LoginState {
  final LoginResponse response;
  final String password;

  const LoginSuccessState({
    required this.response,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [response];
}
