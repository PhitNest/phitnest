import '../../../../domain/entities/entities.dart';
import 'registration_event.dart';

/// This event is emitted when the user selects a gym
class GymSelectedEvent extends RegistrationEvent {
  final GymEntity gym;

  GymSelectedEvent(this.gym);

  @override
  List<Object> get props => [gym];
}
