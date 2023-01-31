import 'package:equatable/equatable.dart';

export 'initial.dart';
export 'gyms_loading.dart';
export 'gyms_loading_error.dart';
export 'gyms_loaded.dart';
export 'gym_selected/gym_selected.dart';
export 'register_success.dart';
export 'upload/upload.dart';

/// Base class for all registration states.
abstract class RegistrationState extends Equatable {
  const RegistrationState() : super();

  @override
  List<Object?> get props => [];
}
