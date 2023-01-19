import 'package:equatable/equatable.dart';

export 'initial.dart';
export 'gyms_loading_error.dart';
export 'gyms_loaded/gyms_loaded.dart';
export 'gyms_loaded/gym_not_selected.dart';
export 'gyms_loaded/gym_selected.dart';

abstract class RegistrationState extends Equatable {
  final bool firstNameConfirmed;

  const RegistrationState({
    required this.firstNameConfirmed,
  }) : super();

  @override
  List<Object?> get props => [firstNameConfirmed];
}
