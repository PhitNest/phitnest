import '../../../../data/data_sources/backend/backend.dart';
import 'registration_state.dart';

class UploadSuccessState extends RegistrationState {
  final RegisterResponse registration;

  const UploadSuccessState({
    required this.registration,
  }) : super();

  @override
  List<Object> get props => [registration];
}
