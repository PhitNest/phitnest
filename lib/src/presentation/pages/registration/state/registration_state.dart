import 'package:equatable/equatable.dart';

export 'uploading_photo/uploading_base.dart';
export 'initial/initial.dart';
export 'upload_success.dart';

/// Base class for all registration states.
abstract class RegistrationState extends Equatable {
  const RegistrationState() : super();

  @override
  List<Object?> get props => [];
}
