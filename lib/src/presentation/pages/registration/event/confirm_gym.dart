import 'registration_event.dart';

/// This event is emitted when the user confirms that they belong to the gym
/// they have selected.
class ConfirmGymEvent extends RegistrationEvent {
  const ConfirmGymEvent();

  @override
  List<Object?> get props => [];
}
