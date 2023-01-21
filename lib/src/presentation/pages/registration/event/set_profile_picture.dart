import 'package:image_picker/image_picker.dart';

import 'registration_event.dart';

/// This event is emitted when the profile picture is submitted
class SetProfilePictureEvent extends RegistrationEvent {
  final XFile image;

  const SetProfilePictureEvent(this.image) : super();

  @override
  List<Object> get props => [image];
}
