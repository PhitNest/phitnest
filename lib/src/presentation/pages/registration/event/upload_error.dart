import '../../../../common/failure.dart';
import 'registration_event.dart';

class UploadErrorEvent extends RegistrationEvent {
  final Failure failure;

  const UploadErrorEvent(this.failure) : super();

  @override
  List<Object> get props => [failure];
}
