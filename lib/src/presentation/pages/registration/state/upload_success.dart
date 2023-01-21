import '../../../../data/data_sources/backend/backend.dart';
import 'registration_state.dart';

class UploadSuccessState extends RegistrationState {
  final RegisterResponse registration;
  final String password;

  const UploadSuccessState({
    required this.registration,
    required this.password,
  }) : super();

  @override
  List<Object> get props => [registration, password];
}
