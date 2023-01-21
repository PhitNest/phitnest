import '../../../../common/failure.dart';
import 'registration_event.dart';

/// This event is emitted if there is an error loading gyms
class GymsLoadingErrorEvent extends RegistrationEvent {
  final Failure failure;

  const GymsLoadingErrorEvent(this.failure) : super();

  @override
  List<Object?> get props => [failure];
}
