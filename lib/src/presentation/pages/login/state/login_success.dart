import '../../../../data/data_sources/auth/auth.dart';
import 'login_state.dart';

class LoginSuccessState extends LoginState {
  final LoginResponse response;

  const LoginSuccessState({required this.response}) : super();

  @override
  List<Object?> get props => [response];
}
