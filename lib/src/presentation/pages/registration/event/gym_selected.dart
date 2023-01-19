import '../../../../domain/entities/entities.dart';
import 'registration_event.dart';

class GymSelectedEvent extends RegistrationEvent {
  final GymEntity gym;

  GymSelectedEvent(this.gym);

  @override
  List<Object> get props => [gym];
}
