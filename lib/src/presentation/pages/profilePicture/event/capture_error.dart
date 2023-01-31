import '../../../../common/failure.dart';
import 'profile_picture_event.dart';

class CaptureErrorEvent extends ProfilePictureEvent {
  final Failure failure;

  const CaptureErrorEvent(this.failure);

  @override
  List<Object?> get props => [failure];
}
