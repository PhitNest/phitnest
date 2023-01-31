import 'package:equatable/equatable.dart';

export 'edit_first_name.dart';
export 'loaded_gyms.dart';
export 'gyms_loading_error.dart';
export 'gym_selected.dart';
export 'swipe.dart';
export 'submit_page_one.dart';
export 'submit_page_two.dart';
export 'retry_load_gyms.dart';
export 'register.dart';
export 'register_error.dart';
export 'register_success.dart';

/// This is the base event for the registration page
abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent() : super();

  @override
  List<Object?> get props => [];
}
