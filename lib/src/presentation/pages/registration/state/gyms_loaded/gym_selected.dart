import '../../../../../domain/entities/entities.dart';
import 'gyms_loaded.dart';

class GymSelectedState extends GymsLoadedState {
  final GymEntity gym;

  GymSelectedEvent(this.gym);

  @override
  List<Object> get props => [gym];
}