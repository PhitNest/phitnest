import 'registration_event.dart';

/// This event is emitted when the user edits their first name.
class EditFirstNameEvent extends RegistrationEvent {
  final String? firstName;

  const EditFirstNameEvent(this.firstName) : super();

  @override
  List<Object?> get props => [firstName];
}
