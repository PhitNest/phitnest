import 'package:camera/camera.dart';

import '../../../../common/failure.dart';
import '../../../../data/data_sources/backend/backend.dart';
import 'registration_state.dart';

class UploadErrorState extends RegistrationState {
  final Failure failure;
  final XFile photo;
  final RegisterResponse registration;

  const UploadErrorState({
    required this.failure,
    required this.photo,
    required this.registration,
  }) : super();

  @override
  List<Object> get props => [failure, photo, registration];
}
