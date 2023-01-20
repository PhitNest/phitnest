import 'package:image_picker/image_picker.dart';

import 'registration_event.dart';

class SetProfilePictureEvent extends RegistrationEvent {
  final XFile image;

  const SetProfilePictureEvent(this.image) : super();

  @override
  List<Object> get props => [image];
}
