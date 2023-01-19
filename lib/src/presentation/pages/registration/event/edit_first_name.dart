import 'registration_event.dart';

class EditFirstNameEvent extends RegistrationEvent {
  final String? firstName;

  const EditFirstNameEvent(this.firstName) : super();

  @override
  List<Object?> get props => [firstName];
}
