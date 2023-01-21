import '../../../../domain/entities/entities.dart';
import 'registration_event.dart';

/// This event is emitted when the gyms have finished loading
class GymsLoadedEvent extends RegistrationEvent {
  final List<GymEntity> gyms;
  final LocationEntity location;

  GymsLoadedEvent(this.gyms, this.location);

  @override
  List<Object> get props => [gyms, location];
}
