import '../../../../data/backend/backend.dart';
import 'registration_state.dart';

class RegisterSuccessState extends RegistrationState {
  final RegisterResponse response;
  final String password;

  const RegisterSuccessState({
    required this.response,
    required this.password,
  }) : super();

  @override
  List<Object> get props => [super.props, response, password];
}
