import 'package:async/async.dart';
import 'package:camera/camera.dart';

import '../../../../common/failure.dart';
import '../../../../data/data_sources/backend/backend.dart';
import 'registration_state.dart';

class UploadingPhotoState extends RegistrationState {
  final CancelableOperation<Failure?> uploadOp;
  final XFile photo;
  final RegisterResponse registration;

  const UploadingPhotoState({
    required this.uploadOp,
    required this.photo,
    required this.registration,
  }) : super();

  @override
  List<Object> get props => [
        uploadOp.isCompleted,
        uploadOp.isCanceled,
        photo,
        registration,
      ];
}
