import 'package:equatable/equatable.dart';

export 'initial.dart';
export 'register_base.dart';
export 'upload_error.dart';
export 'upload_success.dart';
export 'uploading_photo.dart';
export 'gyms_loading_error.dart';
export 'gyms_loaded/gyms_loaded.dart';
export 'gyms_loaded/gym_not_selected.dart';
export 'gyms_loaded/gym_selected/gym_selected.dart';
export 'gyms_loaded/gym_selected/camera_error.dart';
export 'gyms_loaded/gym_selected/capture_error.dart';
export 'gyms_loaded/gym_selected/capturing.dart';
export 'gyms_loaded/gym_selected/photo_selected/photo_selected.dart';
export 'gyms_loaded/gym_selected/photo_selected/registering.dart';
export 'gyms_loaded/gym_selected/photo_selected/register_error.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState() : super();

  @override
  List<Object?> get props => [];
}
