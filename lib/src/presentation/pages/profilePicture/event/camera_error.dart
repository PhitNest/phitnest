import '../../../../common/failure.dart';
import 'profile_picture_event.dart';

class CameraErrorEvent extends ProfilePictureEvent {
  final Failure failure;

  const CameraErrorEvent(this.failure);

  @override
  List<Object?> get props => [failure];
}
