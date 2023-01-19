import '../../../../common/failure.dart';
import 'registration_event.dart';

class GymsLoadingErrorEvent extends RegistrationEvent {
  final Failure failure;

  const GymsLoadingErrorEvent(this.failure) : super();

  @override
  List<Object?> get props => [failure];
}
