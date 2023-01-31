import 'package:image_picker/image_picker.dart';

import 'registration_event.dart';

class UploadEvent extends RegistrationEvent {
  final XFile file;

  const UploadEvent(this.file) : super();

  @override
  List<Object> get props => [file];
}
