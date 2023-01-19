import '../../../../common/failure.dart';
import './registration_state.dart';

class GymsLoadingErrorState extends RegistrationState {
  final Failure failure;

  const GymsLoadingErrorState({
    required super.firstNameConfirmed,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [super.props, failure];
}
