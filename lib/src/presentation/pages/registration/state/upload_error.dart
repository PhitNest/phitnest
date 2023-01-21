import 'package:camera/camera.dart';

import '../../../../common/failure.dart';
import '../../../../data/data_sources/backend/backend.dart';
import 'registration_state.dart';

class UploadErrorState extends RegistrationState {
  final Failure failure;
  final XFile photo;
  final RegisterResponse registration;
  final String password;

  const UploadErrorState({
    required this.failure,
    required this.photo,
    required this.registration,
    required this.password,
  }) : super();

  @override
  List<Object> get props => [failure, photo, registration, password];
}
