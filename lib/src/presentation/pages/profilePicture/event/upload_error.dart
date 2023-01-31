import '../../../../common/failure.dart';
import 'profile_picture_event.dart';

class UploadErrorEvent extends ProfilePictureEvent {
  final Failure failure;

  const UploadErrorEvent(this.failure) : super();

  @override
  List<Object?> get props => [failure];
}
