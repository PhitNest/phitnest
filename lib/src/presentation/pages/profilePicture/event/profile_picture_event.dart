import 'package:equatable/equatable.dart';

export 'initialized.dart';
export 'camera_error.dart';
export 'camera_loaded.dart';
export 'capture.dart';
export 'capture_error.dart';
export 'capture_success.dart';
export 'retake_photo.dart';
export 'retry_initialize_camera.dart';
export 'upload_error.dart';
export 'upload_success.dart';
export 'upload.dart';

/// Base event for the profile picture screen
abstract class ProfilePictureEvent extends Equatable {
  const ProfilePictureEvent() : super();

  @override
  List<Object?> get props => [];
}
