import 'package:camera/camera.dart';

import '../../../../../data/data_sources/backend/backend.dart';
import '../registration_state.dart';

export 'upload_error.dart';
export 'uploading_photo.dart';

/// This is the base state for when the user is uploading their profile picture
abstract class UploadingPhotoBaseState extends RegistrationState {
  /// This is the photo the user is uploading.
  final XFile photo;

  /// This is the response from the users registration.
  final RegisterResponse registration;

  const UploadingPhotoBaseState({
    required this.photo,
    required this.registration,
  }) : super();

  @override
  List<Object> get props => [photo, registration];
}
