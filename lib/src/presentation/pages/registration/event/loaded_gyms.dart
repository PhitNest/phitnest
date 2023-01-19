import '../../../../domain/entities/entities.dart';
import 'registration_event.dart';

class LoadedGymsEvent extends RegistrationEvent {
  final List<GymEntity> gyms;
  final LocationEntity location;

  LoadedGymsEvent(this.gyms, this.location);

  @override
  List<Object> get props => [gyms, location];
}
