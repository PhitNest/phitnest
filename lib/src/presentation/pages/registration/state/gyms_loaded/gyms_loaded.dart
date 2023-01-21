import '../../../../../domain/entities/entities.dart';
import '../register_base.dart';

abstract class GymsLoadedState extends RegistrationBase {
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
