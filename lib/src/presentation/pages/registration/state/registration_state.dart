import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

export 'initial.dart';
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
export 'gyms_loaded/gym_selected/photo_selected/uploading_photo.dart';

abstract class RegistrationState extends Equatable {
  final bool firstNameConfirmed;
  final int currentPage;
  final AutovalidateMode autovalidateMode;

  const RegistrationState({
    required this.firstNameConfirmed,
    required this.currentPage,
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object?> get props =>
      [firstNameConfirmed, currentPage, autovalidateMode];
}
