import '../../../../../domain/entities/entities.dart';
import 'gyms_loaded.dart';

class GymSelectedState extends GymsLoadedState {
  final GymEntity gym;

  GymSelectedState({
    required super.firstNameConfirmed,
    required super.location,
    required super.gyms,
    required this.gym,
  }) : super();

  @override
  List<Object> get props => [gym];
}
