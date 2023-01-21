import 'package:equatable/equatable.dart';

export 'edit_first_name.dart';
export 'loaded_gyms.dart';
export 'gyms_loading_error.dart';
export 'gym_selected.dart';
export 'confirm_gym.dart';
export 'swipe.dart';
export 'submit_page_one.dart';
export 'submit_page_two.dart';
export 'retry_load_gyms.dart';
export 'read_photo_instructions.dart';
export 'set_profile_picture.dart';
export 'retry_camera_init.dart';
export 'capture_photo.dart';
export 'capture_error.dart';
export 'retake_profile_picture.dart';
export 'register.dart';
export 'register_error.dart';
export 'register_success.dart';
export 'upload_photo_error.dart';
export 'upload_success.dart';
export 'retry_photo_upload.dart';

/// This is the base event for the registration page
abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent() : super();
}
