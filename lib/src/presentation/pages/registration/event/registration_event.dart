import 'package:equatable/equatable.dart';

export 'edit_first_name.dart';
export 'loaded_gyms.dart';
export 'gyms_loading_error.dart';
export 'gym_selected.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent() : super();
}
