import '../../../../../domain/entities/entities.dart';
import '../registration_state.dart';

abstract class GymsLoadedState extends RegistrationState {
  final LocationEntity location;
  final List<GymEntity> gyms;

  const GymsLoadedState({
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.autovalidateMode,
    required this.location,
    required this.gyms,
  }) : super();

  @override
  List<Object?> get props => [super.props, location, gyms];
}
